# -*- coding: utf-8 -*-

require 'turnip_formatter/template'

module TurnipFormatter
  class Template
    module Tab
      class TagStatistics
        attr_reader :scenarios

        #
        # @param [Array]  passed_examples  Array of TurnipFormatter::Scenario
        #
        def initialize(scenarios)
          @scenarios = scenarios
        end

        def build
          html = <<-EOS
            <table>
              <thead>
                <tr>
                  <th>Tag</th>
                  <th>Scearios</th>
                  <th>passed</th>
                  <th>failed</th>
                  <th>pending</th>
                  <th>status</th>
                </tr>
              </thead>
              <tbody>
          EOS
          
          html += tag_analysis.map { |info| build_tr(info) }.join
          html += '</tbody></table>'
        end

        private

        def tag_analysis
          group_by_tag.map do |tag, scenarios|
            status_group = scenarios.group_by { |s| s[:scenario].status }
            info = OpenStruct.new(
              name: tag,
              scenarios: scenarios.count,
              passed: status_count(status_group["passed"]),
              failed: status_count(status_group["failed"]),
              pending: status_count(status_group["pending"]),
              status: 'failed'
            )
            info.status = (info.pending.zero? ? 'passed' : 'pending') if info.failed.zero?
            info
          end
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
        #        a: [3, 4],
        #        b: [3, 5]
        #      ]
        # 
        #
        def group_by_tag
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

        def build_tr(info)
          <<-EOS
            <tr>
              <td>#{info.name}</td>
              <td>#{info.scenarios}</td>
              <td>#{info.passed}</td>
              <td>#{info.failed}</td>
              <td>#{info.pending}</td>
              <td class="#{info.status}">#{info.status}</td>
            </tr>
          EOS
        end
      end
    end
  end
end
