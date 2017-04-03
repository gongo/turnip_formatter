require 'turnip_formatter/resource/scenario/base'

module TurnipFormatter
  module Resource
    module Scenario
      class Pending < Base
        #
        # Mark status for each step
        #
        # example:
        #
        #   When foo
        #    And bar <= pending line
        #   Then baz
        #
        #   # @steps => [
        #   #   <Step::Step 'foo'>  # .status => :passed
        #   #   <Step::Step 'bar'>  # .status => :pending
        #   #   <Step::Step 'baz'>  # .status => :unexecute
        #   # ]
        #
        def mark_status
          @steps.each do |step|
            step.mark_as_executed

            if pending_line_number == step.line
              step.set_pending(
                example.execution_result.pending_message,
                example.location
              )
              break
            end
          end
        end

        private

        def pending_line_number
          example.metadata[:line_number]
        end
      end
    end
  end
end
