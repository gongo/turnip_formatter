# -*- coding: utf-8 -*-

require 'turnip_formatter/scenario'
require 'turnip_formatter/step/failure'

module TurnipFormatter
  module Scenario
    class NotFailedScenarioError < ::StandardError; end
    class NoExistFailedStepInformationError < ::StandardError; end

    class Failure
      include TurnipFormatter::Scenario

      def steps
        steps = super
        steps[offending_line].extend TurnipFormatter::Step::Failure
        steps
      end

      def validation
        raise NotFailedScenarioError if status != 'failed'
        offending_line
        super
      end

      private

      def offending_line
        unless example.exception.backtrace.last =~ /:in step:(?<stepno>\d+) `/
          raise NoExistFailedStepInformationError
        end
        $~[:stepno].to_i
      end
    end
  end
end
