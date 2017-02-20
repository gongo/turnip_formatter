require 'turnip_formatter/resource/scenario/base'
require 'turnip_formatter/resource/step/failure'
require 'turnip_formatter/resource/hook'
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

          return steps_with_error_in_before_hook if error_in_before_hook?(exceptions)

          steps = steps_with_error(exceptions)
          if error_in_after_hook?(exceptions)
            steps + [TurnipFormatter::Resource::Hook.new(example, 'AfterHook', :failed)]
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

        def steps_with_error_in_before_hook
          before_step = TurnipFormatter::Resource::Hook.new(example, 'BeforeHook', :failed)
          after_steps = raw_steps.map do |rs|
            TurnipFormatter::Resource::Step::Unexecute.new(example, rs)
          end

          [before_step] + after_steps
        end

        def error_in_before_hook?(exceptions)
          extra_exceptions = exceptions[nil]
          return false if extra_exceptions.nil?

          extra_exceptions.first.backtrace.any? do |backtrace|
            backtrace.match(/run_before_example/)
          end
        end

        def error_in_after_hook?(exceptions)
          extra_exceptions = exceptions[nil]
          return false if extra_exceptions.nil?

          extra_exceptions.last.backtrace.any? do |backtrace|
            backtrace.match(/run_after_example/)
          end
        end

        def all_exception_group_by_line_number
          all_exception(example.exception).group_by { |e| failed_line_number(e) }
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
          line = exception.backtrace.find do |backtrace|
            backtrace.match(/#{filepath}:(\d+):in `run_step'/)
          end

          Regexp.last_match[1].to_i if line
        end
      end
    end
  end
end
