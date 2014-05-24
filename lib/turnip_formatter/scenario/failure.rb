require 'turnip_formatter/scenario/base'

module TurnipFormatter
  module Scenario
    class Failure < Base
      def steps
        steps = super
        steps[@offending_line].status = :failed
        steps
      end

      def valid?
        if failed_message =~ /:in step:(?<stepno>\d+) `/
          @offending_line = $~[:stepno].to_i
        else
          @errors << 'has no failed step information'
        end

        super
      end

      private

        def failed_message
          example.exception.backtrace.last
        end
    end
  end
end
