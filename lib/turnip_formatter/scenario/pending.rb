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
        steps[offending_line].extend TurnipFormatter::Step::Pending
        steps
      end

      def validation
        raise NotPendingScenarioError if status != 'pending'
        offending_line
        super
      end

      private

      def offending_line
        unless pending_message =~ /^No such step\((?<stepno>\d+)\): /
          raise NoExistPendingStepInformationError
        end
        $~[:stepno].to_i
      end

      def pending_message
        example.execution_result[:pending_message]
      end
    end
  end
end
