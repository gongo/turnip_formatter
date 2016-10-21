require 'turnip_formatter/resource/scenario/base'

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
        #
        # @todo failed_at_before_hook, failed_at_after_hook GH-67
        #
        def steps
          steps = super

          arys = steps.group_by { |s| (s.line <=> failed_line_number).to_s }
          arys['-1'].each { |s| s.status = :passed    } unless arys['-1'].nil?
          arys['0'].each  { |s| s.status = :failed    } unless arys['0'].nil?
          arys['1'].each  { |s| s.status = :unexecute } unless arys['1'].nil?

          steps
        end

        private

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
