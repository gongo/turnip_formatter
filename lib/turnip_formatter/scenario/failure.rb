# -*- coding: utf-8 -*-

require 'turnip_formatter/scenario'
require 'turnip_formatter/step/failure'
require 'rspec/core/formatters/helpers'

module TurnipFormatter
  module Scenario
    class NotFailedScenarioError < ::StandardError; end
    class NoExistFailedStepInformationError < ::StandardError; end

    class Failure
      include TurnipFormatter::Scenario
      include RSpec::Core::BacktraceFormatter

      def steps
        steps = super
        steps[offending_line].tap do |step|
          step.extend TurnipFormatter::Step::Failure
          step.attention(exception, backtrace)
        end
        steps
      end

      def validation
        raise NotFailedScenarioError if (status != 'failed')
        offending_line
        super
      end

      private

      def offending_line
        unless backtrace.last =~ /:in step:(?<stepno>\d+) `/
          raise NoExistFailedStepInformationError
        end
        $~[:stepno].to_i
      end

      def backtrace
        @backtrace ||= format_backtrace(exception.backtrace, scenario.metadata).map do |b|
          backtrace_line(b)
        end.compact
      end
    end
  end
end
