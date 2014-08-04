# -*- coding: utf-8 -*-

require 'turnip_formatter/html/printer'
require 'ostruct'

module TurnipFormatter
  module Html
    module Printer
      class TabTagStatistics
        class << self
          include TurnipFormatter::Html::Printer

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
            status_group.default = []

            info = OpenStruct.new(
              name: name,
              scenario_count: scenarios.size,
              passed_count: status_group['passed'].size,
              failed_count: status_group['failed'].size,
              pending_count: status_group['pending'].size,
              status: 'failed'
              )

            if info.failed_count.zero?
              info.status = info.pending_count.zero? ? 'passed' : 'pending'
            end

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
              if scenario.valid?
                if scenario.tags.empty?
                  { name: 'turnip', scenario: scenario }
                else
                  scenario.tags.map do |tag|
                    { name: '@' + tag, scenario: scenario }
                  end
                end
              else
                { name: 'runtime error', scenario: scenario }
              end
            end.flatten.group_by { |s| s[:name] }.sort
          end
        end
      end
    end
  end
end
