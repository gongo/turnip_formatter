# -*- coding: utf-8 -*-

require 'turnip_formatter/scenario'
require 'turnip_formatter/step/pending'

module TurnipFormatter
  module Scenario
    class NotPendingScenarioError < ::StandardError; end
    class NoExistPendingStepInformationError < ::StandardError; end

    class Pending
      include TurnipFormatter::Scenario

      def steps
        steps = super
        steps[offending_line].tap do |step|
          step.extend TurnipFormatter::Step::Pending
          step.attention(pending_message, scenario.location)
        end
        steps
      end

      def validation
        raise NotPendingScenarioError if status != 'pending'
        offending_line
        super
      end

      private

      def offending_line
        raise NoExistPendingStepInformationError unless pending_message =~ /^No such step\((?<stepno>\d+)\): /
        $~[:stepno].to_i
      end
    end
  end
end
