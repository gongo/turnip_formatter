# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/printer/index'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_reader :passed_scenarios, :failed_scenarios, :pending_scenarios
        attr_reader :scenarios

        def initialize(output)
          super(output)
          @passed_scenarios  = []
          @failed_scenarios  = []
          @pending_scenarios = []
          @scenarios = []
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
          super(duration, example_count, failure_count, pending_count)
          output.puts ::TurnipFormatter::Printer::Index.print_out(self)
        end

        def example_passed(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Pass.new(example)
          @passed_scenarios << scenario
          @scenarios << scenario
        end

        def example_pending(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Pending.new(example)
          @pending_scenarios << scenario
          @scenarios << scenario
        end

        def example_failed(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Failure.new(example)
          @failed_scenarios << scenario
          @scenarios << scenario
        end
      end
    end
  end
end
