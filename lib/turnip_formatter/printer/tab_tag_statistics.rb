# -*- coding: utf-8 -*-

require 'turnip_formatter/printer'
require 'ostruct'

module TurnipFormatter
  module Printer
    class TabTagStatistics
      class << self
        include TurnipFormatter::Printer

        def print_out(scenarios)
          tags = group_by_tag(scenarios)

          results = tags.map do |name, tag_scenarios|
            tag_analysis(name, tag_scenarios)
          end

          render_template(:tab_tag_statistics, { analysis_results: results })
        end

        private

        def tag_analysis(name, scenarios)
          status_group = scenarios.group_by { |s| s[:scenario].status }

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

        #
        # Image...
        #
        # [
        #   { tags: [:a, :b], val: 3 },
        #   { tags: [:a], val: 4 },
        #   { tags: [:b], val: 5 },
        # ]
        # # => [
        #        [:a, [3, 4]],
        #        [:b, [3, 5]],
        #      ]
        #
        #
        def group_by_tag(scenarios)
          scenarios.map do |scenario|
            if scenario.tags.empty?
              { name: 'turnip', scenario: scenario }
            else
              scenario.tags.map do |tag|
                { name: '@' + tag, scenario: scenario }
              end
            end
          end.flatten.group_by { |s| s[:name] }.sort
        end

        def status_count(scenarios)
          scenarios.nil? ? 0 : scenarios.count
        end
      end
    end
  end
end
