require 'turnip_formatter/resource/step/base'

module TurnipFormatter
  module Resource
    module Step
      class Pending < Base
        def status
          :pending
        end

        def pending_message
          example.execution_result.pending_message
        end

        def pending_location
          example.location
        end
      end
    end
  end
end
