# -*- coding: utf-8 -*-

require 'turnip_formatter/printer'
require 'ostruct'

module TurnipFormatter
  module Printer
    module TabFeatureStatistics
      class << self
        include TurnipFormatter::Printer

        def print_out(scenarios)
          features = scenarios.group_by { |s| s.feature_name }

          results = features.map do |name, feature_scenarios|
            feature_analysis(name, feature_scenarios)
          end

          render_template(:tab_feature_statistics, { analysis_results: results })
        end

        private

        def feature_analysis(name, scenarios)
          status_group = scenarios.group_by { |s| s.status }
          status_group.default = []

          info = OpenStruct.new(
            name: name,
            scenario_count: scenarios.size,
            passed_count: status_group["passed"].size,
            failed_count: status_group["failed"].size,
            pending_count: status_group["pending"].size,
            status: 'failed'
          )

          if info.failed_count.zero?
            info.status = info.pending_count.zero? ? 'passed' : 'pending'
          end

          info
        end
      end
    end
  end
end
