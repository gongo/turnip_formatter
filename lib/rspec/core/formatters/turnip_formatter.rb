# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/template'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_reader :passed_scenarios, :failed_scenarios, :pending_scenarios
        attr_reader :scenarios

        def initialize(output)
          super(output)
          @template = ::TurnipFormatter::Template.new
          @passed_scenarios = []
          @failed_scenarios = []
          @pending_scenarios = []
          @scenarios = []
        end

        def start(example_count)
          super(example_count)
          output.puts @template.print_header
          output.puts @template.print_main_header
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
          output.puts @template.print_main_footer(example_count, failure_count, pending_count, duration)
          output.puts @template.print_tab_speed_statsitics(passed_scenarios)
          output.puts @template.print_tab_feature_statsitics(scenarios)
          output.puts @template.print_tab_tag_statsitics(scenarios)
          output.puts @template.print_footer
        end

        def example_passed(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Pass.new(example)
          @passed_scenarios << scenario

          output_scenario(scenario)
        end

        def example_pending(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Pending.new(example)
          @pending_scenarios << scenario

          output_scenario(scenario)
        end

        def example_failed(example)
          super(example)

          scenario = ::TurnipFormatter::Scenario::Failure.new(example)
          @failed_scenarios << scenario

          output_scenario(scenario)
        end

        private

        def output_scenario(scenario)
          scenario.validation
          @scenarios << scenario
          output.puts @template.print_scenario(scenario)
        rescue => e
          output_runtime_error(e)
        end

        def output_runtime_error(exception)
          output.puts @template.print_runtime_error(examples.last, exception)
        end
      end
    end
  end
end
