module TurnipFormatter
  class Step
    module Failure
      def attention?
        true
      end

      def attention(exception, backtrace)
        exception.set_backtrace(backtrace)
        docs[:source]    = backtrace.first
        docs[:exception] = exception
      end

      def status
        'failure'
      end
    end
  end
end
