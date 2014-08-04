# -*- coding: utf-8 -*-

require 'rspec/core/formatters/turnip_base_formatter'
require 'turnip_formatter/html/printer/index'
require 'turnip_formatter/html/printer/scenario'

module RSpec
  module Core
    module Formatters
      class TurnipHtmlFormatter < TurnipBaseFormatter
        attr_reader :scenario_output_files

        SCENARIO_TEMPORARY_OUTPUT_DIR = File.expand_path('./turnip_tmp')

        def initialize(output)
          super(output)
          @scenario_output_files = []
          FileUtils.mkdir_p(SCENARIO_TEMPORARY_OUTPUT_DIR)
        end

        def output_summary(params)
          output.puts ::TurnipFormatter::Html::Printer::Index.print_out(params)
          FileUtils.rm_rf(SCENARIO_TEMPORARY_OUTPUT_DIR)
        end

        def output_scenario(scenario)
          super(scenario)

          filepath = SCENARIO_TEMPORARY_OUTPUT_DIR + "/#{scenario.id}.html"

          File.open(filepath, 'w') do |io|
            io.puts ::TurnipFormatter::Html::Printer::Scenario.print_out(scenario)
          end

          @scenario_output_files << filepath
        end
      end
    end
  end
end
