# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require_relative './turnip_formatter/for_rspec2'
require_relative './turnip_formatter/for_rspec3'

module RSpec
  module Core
    module Formatters
      class TurnipBaseFormatter < BaseFormatter
        attr_reader :scenarios

        def self.inherited(child)
          if Formatters.respond_to?(:register)
            child.include TurnipFormatter::ForRSpec3
          else
            child.include TurnipFormatter::ForRSpec2
          end
        end

        def initialize(output)
          super(output)
          @scenarios = []
        end

        def output_summary(params)
        end

        def output_scenario(scenario)
          @scenarios << scenario
        end
      end
    end
  end
end
