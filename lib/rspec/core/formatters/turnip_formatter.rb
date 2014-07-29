# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/printer/index'
require 'turnip_formatter/printer/scenario'
require_relative './turnip_formatter/for_rspec2'
require_relative './turnip_formatter/for_rspec3'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_reader :scenarios, :scenario_output_files

        SCENARIO_TEMPORARY_OUTPUT_DIR = File.expand_path('./turnip_tmp')

        if Formatters.respond_to?(:register)
          include TurnipFormatter::ForRSpec3
          Formatters.register self, :example_passed, :example_pending, :example_failed, :dump_summary
        else
          include TurnipFormatter::ForRSpec2
        end

        def initialize(output)
          super(output)
          @scenarios = []
          @scenario_output_files = []

          FileUtils.mkdir_p(SCENARIO_TEMPORARY_OUTPUT_DIR)
        end

        private

          def output_html(params)
            output.puts ::TurnipFormatter::Printer::Index.print_out(params)
            FileUtils.rm_rf(SCENARIO_TEMPORARY_OUTPUT_DIR)
          end

          def output_scenario(scenario)
            filepath = SCENARIO_TEMPORARY_OUTPUT_DIR + "/#{scenario.id}.html"

            File.open(filepath, 'w') do |io|
              io.puts ::TurnipFormatter::Printer::Scenario.print_out(scenario)
            end

            @scenario_output_files << filepath
            @scenarios << scenario
          end
      end
    end
  end
end
