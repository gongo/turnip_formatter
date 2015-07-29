require 'turnip_formatter/scenario/base'

module TurnipFormatter
  module Scenario
    class Pending < Base
      def steps
        steps = super
        return steps unless pending_line_number

        steps.each do |step|
          case
          when step.line == pending_line_number
            step.status = :pending
          when step.line > pending_line_number
            step.status = :unexecuted
          end
        end

        puts 'PENDING1' if step.status == :pending
        steps
      end

      protected

      def validation
        @errors << 'has no pending step information' unless pending_line_number
        super
      end

      private

      def pending_line_number
        example.metadata[:line_number]
      end

      def pending_message
        result = TurnipFormatter::Helper.example_execution_result(example)
        result.pending_message
      end
    end
  end
end
