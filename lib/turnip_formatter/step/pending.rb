module TurnipFormatter
  class Step
    module Pending
      def attention?
        true
      end

      def attention(message, location)
        exception = RSpec::Core::Pending::PendingDeclaredInExample.new(message)
        exception.set_backtrace(location)
        docs[:exception] = exception
      end

      def status
        'pending'
      end
    end
  end
end
