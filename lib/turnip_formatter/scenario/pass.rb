# -*- coding: utf-8 -*-

require 'turnip_formatter/scenario'
require 'turnip_formatter/step/pending'

module TurnipFormatter
  module Scenario
    class NotPassedScenarioError < ::StandardError; end

    class Pass
      include TurnipFormatter::Scenario

      def validation
        raise NotPassedScenarioError if status != 'passed'
        super
      end
    end
  end
end
