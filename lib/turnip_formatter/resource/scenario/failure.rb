require 'turnip_formatter/resource/scenario/base'
require 'rspec/core/formatters/exception_presenter'

module TurnipFormatter
  module Resource
    module Scenario
      class Failure < Base
        alias :super_steps :steps

        #
        # Mark status for each step
        #
        # example:
        #
        #   When foo
        #    And bar <= failed line
        #   Then baz
        #
        #   # @steps => [
        #   #   <Step::Step 'foo'>  # .status => :passed
        #   #   <Step::Step 'bar'>  # .status => :failed
        #   #   <Step::Step 'baz'>  # .status => :unexecute
        #   # ]
        #
        # example: aggregate_failures = true
        #
        #   # @steps => [
        #   #   <Step::Step 'foo'>  # .status => :passed
        #   #   <Step::Step 'bar'>  # .status => :failed
        #   #   <Step::Step 'baz'>  # .status => :passed
        #   # ]
        #
        # example: Occurs error in RSpec before hook
        #
        #   # @steps => [
        #   #   <Step::BeforeHook ''> # .status => :failed
        #   #   <Step::Step 'foo'>    # .status => :unexecute
        #   #   <Step::Step 'bar'>    # .status => :unexecute
        #   #   <Step::Step 'baz'>    # .status => :unexecute
        #   # ]
        #
        # example: Occurs error in RSpec after hook
        #
        #   # @steps => [
        #   #   <Step::Step 'foo'>    # .status => :passed
        #   #   <Step::Step 'bar'>    # .status => :failed
        #   #   <Step::Step 'baz'>    # .status => :unexecute
        #   #   <Step::AfterHook ''>  # .status => :failed
        #   # ]
        #
        def mark_status
          exceptions = all_exception_group_by_line_number

          if exceptions.has_key?(:before)
            before_step = TurnipFormatter::Resource::Step::BeforeHook.new(example)
            before_step.set_exceptions(exceptions[:before])
            @steps.unshift(before_step)
            return
          end

          @steps.each do |step|
            step.mark_as_executed
            exs = exceptions[step.line]

            next unless exs
            step.set_exceptions(exs)

            break if !example.metadata[:aggregate_failures]
          end

          if exceptions.has_key?(:after)
            after_step = TurnipFormatter::Resource::Step::AfterHook.new(example)
            after_step.set_exceptions(exceptions[:after])
            @steps.push(after_step)
          end
        end

        private

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
                     '<eval>'
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
