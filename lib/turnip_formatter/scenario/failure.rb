require 'turnip_formatter/scenario/base'

module TurnipFormatter
  module Scenario
    class Failure < Base
      def steps
        steps = super
        return steps unless failed_line_number

        steps.each do |step|
          case
          when step.line == failed_line_number
            step.status = :failed
          when step.line > failed_line_number
            step.status = :unexecuted
          end
        end

        steps
      end

      protected

      def validation
        @errors << 'has no failed step information' unless failed_line_number
        super
      end

      private

      def failed_line_number
        return @failed_line_number if @failed_line_number
        return unless example.exception

        filepath = File.basename(feature_file_path)
        line = example.exception.backtrace.find do |backtrace|
          backtrace.match(/#{filepath}:(\d+)/)
        end

        @failed_line_number = Regexp.last_match[1].to_i if line
      end
    end
  end
end
