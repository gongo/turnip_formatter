# -*- coding: utf-8 -*-

require 'turnip_formatter/printer'
require 'ostruct'

module TurnipFormatter
  module Printer
    class TabSpeedStatistics
      class << self
        include TurnipFormatter::Printer

        def print_out(scenarios)
          passed_scenarios = scenarios.select { |s| s.status == 'passed' }
          results = speed_analysis(passed_scenarios)
          render_template(:tab_speed_statistics, { analysis_results: results })
        end

        private

        def speed_analysis(scenarios)
          scenarios.map do |s|
            OpenStruct.new(
              {
                id: s.id,
                feature_name: s.feature.name,
                name: s.name,
                run_time: s.run_time
              }
            )
          end.sort { |a, b| a.run_time <=> b.run_time }
        end
      end
    end
  end
end
