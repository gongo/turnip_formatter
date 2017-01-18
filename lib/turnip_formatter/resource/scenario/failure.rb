require 'turnip_formatter/resource/scenario/base'
require 'turnip_formatter/resource/hook'

module TurnipFormatter
  module Resource
    module Scenario
      class Failure < Base
        alias :super_steps :steps

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
        #   #<Step 'foo'>.status = :passed
        #   #<Step 'bar'>.status = :passed
        #   #<Step 'baz'>.status = :failed
        #   #<Step 'piyo'>.status = :unexecute
        #
        # @TODO Correspond to multiple errors.
        #
        # example:
        #
        #   # foo.feature
        #   @after_hook
        #   When foo
        #    And bar  <= failed line
        #   Then baz
        #
        #   # spec_helper.rb
        #   RSpec.configure do |config|
        #     config.after(:example, after_hook: true) do
        #       raise RuntimeError
        #     end
        #   end
        #
        # Currently, display only first error (`And bar`).
        #
        def steps
          case
          when error_in_steps?
            steps_with_error
          when error_in_before_hook?
            steps_with_error_in_before_hook
          when error_in_after_hook?
            steps_with_error_in_after_hook
          end
        end

        private

        def steps_with_error
          steps = super_steps

          arys = steps.group_by { |s| (s.line <=> failed_line_number).to_s }
          arys['-1'].each { |s| s.status = :passed    } unless arys['-1'].nil?
          arys['0'].each  { |s| s.status = :failed    } unless arys['0'].nil?
          arys['1'].each  { |s| s.status = :unexecute } unless arys['1'].nil?

          steps
        end

        def steps_with_error_in_before_hook
          steps = super_steps

          steps.each { |s| s.status = :unexecute }
          [TurnipFormatter::Resource::Hook.new(example, 'BeforeHook', :failed)] + steps
        end

        def steps_with_error_in_after_hook
          super_steps + [TurnipFormatter::Resource::Hook.new(example, 'AfterHook', :failed)]
        end

        def error_in_steps?
          !failed_line_number.nil?
        end

        def error_in_before_hook?
          exception.backtrace.any? do |backtrace|
            backtrace.match(/run_before_example/)
          end
        end

        def error_in_after_hook?
          exception.backtrace.any? do |backtrace|
            backtrace.match(/run_after_example/)
          end
        end

        def failed_line_number
          @failed_line_number ||= (
            filepath = File.basename(feature_file_path)
            line = exception.backtrace.find do |backtrace|
              backtrace.match(/#{filepath}:(\d+)/)
            end
            Regexp.last_match[1].to_i if line
          )
        end

        def exception
          @exception ||= (
            if example.exception.is_a?(RSpec::Core::MultipleExceptionError)
              example.exception.all_exceptions.first
            else
              example.exception
            end
          )
        end
      end
    end
  end
end
