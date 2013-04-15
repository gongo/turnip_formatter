require 'turnip_formatter/scenario'
require 'turnip_formatter/step/pending'

module TurnipFormatter
  module Scenario
    class NotPendingScenarioError < ::StandardError; end

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

      private

      def offending_line
        raise NotPendingScenarioError unless pending_message =~ /^No such step\((?<stepno>\d+)\): /
        $~[:stepno].to_i
      end
    end
  end
end
