# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/printer/index'
require 'turnip_formatter/printer/scenario'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_reader :scenarios, :scenario_output_files

        SCENARIO_TEMPORARY_OUTPUT_DIR = File.expand_path('./turnip_tmp')

        def initialize(output)
          super(output)
          @scenarios = []
          @scenario_output_files = []

          FileUtils.mkdir_p(SCENARIO_TEMPORARY_OUTPUT_DIR)
        end

        def dump_summary(duration, example_count, failure_count, pending_count)
          print_params = {
            scenarios:      scenarios,
            failed_count:   failure_count,
            pending_count:  pending_count,
            total_time:     duration,
            scenario_files: scenario_output_files
          }
          output.puts ::TurnipFormatter::Printer::Index.print_out(print_params)
          FileUtils.rm_rf(SCENARIO_TEMPORARY_OUTPUT_DIR)
        end

        def example_passed(example)
          scenario = ::TurnipFormatter::Scenario::Pass.new(example)
          output_scenario(scenario)
        end

        def example_pending(example)
          clean_backtrace(example)
          scenario = ::TurnipFormatter::Scenario::Pending.new(example)
          output_scenario(scenario)
        end

        def example_failed(example)
          clean_backtrace(example)
          scenario = ::TurnipFormatter::Scenario::Failure.new(example)
          output_scenario(scenario)
        end

        private

          def output_scenario(scenario)
            filepath = SCENARIO_TEMPORARY_OUTPUT_DIR + "/#{scenario.id}.html"

            File.open(filepath, 'w') do |io|
              io.puts ::TurnipFormatter::Printer::Scenario.print_out(scenario)
            end

            @scenario_output_files << filepath
            @scenarios << scenario
          end

          def clean_backtrace(example)
            return if example.exception.nil?
            formatted = format_backtrace(example.exception.backtrace, example)
            example.exception.set_backtrace(formatted)
          end
      end
    end
  end
end
