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

          render_template(:tab_feature_statistics, {analysis_results: results })
        end

        private

        def feature_analysis(name, scenarios)
          status_group = scenarios.group_by { |s| s.status }

          info = OpenStruct.new(
            name: name,
            scenarios: scenarios.count,
            passed: status_count(status_group["passed"]),
            failed: status_count(status_group["failed"]),
            pending: status_count(status_group["pending"]),
            status: 'failed'
          )

          info.status = (info.pending.zero? ? 'passed' : 'pending') if info.failed.zero?

          info
        end

        def status_count(scenarios)
          scenarios.nil? ? 0 : scenarios.count
        end
      end
    end
  end
end
