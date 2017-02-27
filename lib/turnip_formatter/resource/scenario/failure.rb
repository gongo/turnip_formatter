require 'turnip_formatter/resource/scenario/base'
require 'turnip_formatter/resource/step/failure'
require 'turnip_formatter/resource/step/hook'
require 'rspec/core/formatters/exception_presenter'

module TurnipFormatter
  module Resource
    module Scenario
      class Failure < Base
        #
        # Return steps
        #
        # example:
        #
        #   When foo
        #    And bar
        #    And baz  <= failed line
        #   Then piyo
        #
        #   # => [
        #   #   <Step::Pass 'foo'>
        #   #   <Step::Pass 'bar'>
        #   #   <Step::Failure 'baz'>
        #   #   <Step::Unexecute 'piyo'>
        #   # ]
        #
        def steps
          exceptions = all_exception_group_by_line_number

          if exceptions.has_key?(:before)
            return steps_with_error_in_before_hook(exceptions[:before])
          end

          steps = steps_with_error(exceptions)

          if exceptions.has_key?(:after)
            return steps_with_error_in_after_hook(steps, exceptions[:after])
          end

          steps
        end

        private

        def steps_with_error(exceptions)
          step_klass = TurnipFormatter::Resource::Step::Pass

          raw_steps.map do |rs|
            ex = exceptions[rs.line]
            next step_klass.new(example, rs) unless ex

            # The status of step after error step is determined by `aggregate_failures` option
            if example.metadata[:aggregate_failures]
              step_klass = TurnipFormatter::Resource::Step::Pass
            else
              step_klass = TurnipFormatter::Resource::Step::Unexecute
            end

            TurnipFormatter::Resource::Step::Failure.new(example, rs).tap do |step|
              step.set_exceptions(ex)
            end
          end
        end

        def steps_with_error_in_before_hook(exceptions)
          before_step = TurnipFormatter::Resource::Step::BeforeHook.new(example)
          before_step.set_exceptions(exceptions)

          after_steps = raw_steps.map do |rs|
            TurnipFormatter::Resource::Step::Unexecute.new(example, rs)
          end

          [before_step] + after_steps
        end

        def steps_with_error_in_after_hook(steps, exceptions)
          after_step = TurnipFormatter::Resource::Step::AfterHook.new(example)
          after_step.set_exceptions(exceptions)

          steps + [after_step]
        end

        def error_in_before_hook?(exceptions)
          exceptions.has_key?(:before)
        end

        def error_in_after_hook?(exceptions)
          exceptions.has_key?(:after)
        end

        def all_exception_group_by_line_number
          all_exception(example.exception).group_by do |e|
            line = failed_line_number(e)
            next line unless line.nil?

            case
            when occurred_in_before_hook?(e)
              :before
            when occurred_in_after_hook?(e)
              :after
            end
          end
        end

        def all_exception(exception)
          unless exception.class.include?(RSpec::Core::MultipleExceptionError::InterfaceTag)
            return [exception]
          end

          exception.all_exceptions.flat_map do |e|
            all_exception(e)
          end
        end

        def failed_line_number(exception)
          filepath = File.basename(feature_file_path)
          method = if RUBY_PLATFORM == 'java'
                     'block in (eval)'
                   else
                     'run_step'
                   end
          method = Regexp.escape(method)

          line = exception.backtrace.find do |backtrace|
            backtrace.match(/#{filepath}:(\d+):in `#{method}'/)
          end

          Regexp.last_match[1].to_i if line
        end

        def occurred_in_before_hook?(exception)
          exception.backtrace.any? do |backtrace|
            backtrace.match(/run_before_example/)
          end
        end

        def occurred_in_after_hook?(exception)
          exception.backtrace.any? do |backtrace|
            backtrace.match(/run_after_example/)
          end
        end
      end
    end
  end
end
