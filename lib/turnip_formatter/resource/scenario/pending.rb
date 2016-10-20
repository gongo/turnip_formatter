require 'turnip_formatter/resource/scenario/base'

module TurnipFormatter
  module Resource
    module Scenario
      class Pending < Base
        #
        # Return steps
        #
        # example:
        #
        #   When foo
        #    And bar
        #    And baz  <= pending line
        #   Then piyo
        #
        #   #<Step 'foo'>.status = :passed
        #   #<Step 'bar'>.status = :passed
        #   #<Step 'baz'>.status = :pending
        #   #<Step 'piyo'>.status = :unexecute
        #
        def steps
          steps = super

          arys = steps.group_by { |s| (s.line <=> pending_line_number).to_s }

          arys['-1'].each { |s| s.status = :passed    } unless arys['-1'].nil?
          arys['0'].each  { |s| s.status = :pending   } unless arys['0'].nil?
          arys['1'].each  { |s| s.status = :unexecute } unless arys['1'].nil?

          steps
        end

        private

        def pending_line_number
          example.metadata[:line_number]
        end
      end
    end
  end
end
