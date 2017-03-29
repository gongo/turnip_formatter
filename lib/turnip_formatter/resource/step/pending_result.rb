module TurnipFormatter
  module Resource
    module Step
      module PendingResult
        attr_reader :pending_message
        attr_reader :pending_location

        def pending?
          !pending_message.nil?
        end

        def set_pending(message, location)
          @pending_message = message
          @pending_location = location
        end
      end
    end
  end
end
