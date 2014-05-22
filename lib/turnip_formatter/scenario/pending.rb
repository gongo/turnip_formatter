require 'turnip_formatter/scenario/base'
require 'turnip_formatter/step/pending'

module TurnipFormatter
  module Scenario
    class Pending < Base
      def steps
        steps = super
        steps[@offending_line].extend TurnipFormatter::Step::Pending
        steps
      end

      def valid?
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
