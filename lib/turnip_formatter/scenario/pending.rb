require 'turnip_formatter/scenario/base'

module TurnipFormatter
  module Scenario
    class Pending < Base
      def steps
        steps = super
        steps[@offending_line].status = :pending
        steps[(@offending_line + 1)..-1].each do |step|
          step.status = :unexecuted
        end
        steps
      end

      protected

        def validation
          if pending_message =~ /^No such step\((?<stepno>\d+)\): /
            @offending_line = $~[:stepno].to_i
          else
            @errors << 'has no pending step information'
          end

          super
        end

      private

        def pending_message
          example.execution_result[:pending_message]
        end
    end
  end
end
