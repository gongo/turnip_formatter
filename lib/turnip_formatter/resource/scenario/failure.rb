require 'turnip_formatter/resource/scenario/base'
require 'turnip_formatter/resource/hook'

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
        #   #<Step 'foo'>.status = :passed
        #   #<Step 'bar'>.status = :passed
        #   #<Step 'baz'>.status = :failed
        #   #<Step 'piyo'>.status = :unexecute
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
          steps = method(:steps).super_method.call

          arys = steps.group_by { |s| (s.line <=> failed_line_number).to_s }
          arys['-1'].each { |s| s.status = :passed    } unless arys['-1'].nil?
          arys['0'].each  { |s| s.status = :failed    } unless arys['0'].nil?
          arys['1'].each  { |s| s.status = :unexecute } unless arys['1'].nil?

          steps
        end

        def steps_with_error_in_before_hook
          steps = method(:steps).super_method.call

          steps.each { |s| s.status = :unexecute }
          [TurnipFormatter::Resource::Hook.new(example, 'BeforeHook', :failed)] + steps
        end

        def steps_with_error_in_after_hook
          steps = method(:steps).super_method.call
          steps + [TurnipFormatter::Resource::Hook.new(example, 'AfterHook', :failed)]
        end

        def error_in_steps?
          !failed_line_number.nil?
        end

        def error_in_before_hook?
          example.exception.backtrace.any? do |backtrace|
            backtrace.match(/run_before_example/)
          end
        end

        def error_in_after_hook?
          example.exception.backtrace.any? do |backtrace|
            backtrace.match(/run_after_example/)
          end
        end

        def failed_line_number
          @failed_line_number ||= (
            filepath = File.basename(feature_file_path)
            line = example.exception.backtrace.find do |backtrace|
              backtrace.match(/#{filepath}:(\d+)/)
            end
            Regexp.last_match[1].to_i if line
          )
        end
      end
    end
  end
end
