# -*- coding: utf-8 -*-

require 'turnip_formatter/template'

module TurnipFormatter
  class Template
    module Tab
      class FeatureStatistics
        attr_reader :features

        #
        # @param [Array]  passed_examples  Array of TurnipFormatter::Scenario
        #
        def initialize(scenarios)
          @features = scenarios.group_by { |s| s.feature_name }
        end

        def build
          html = <<-EOS
            <table>
              <thead>
                <tr>
                  <th>Feature</th>
                  <th>Scearios</th>
                  <th>passed</th>
                  <th>failed</th>
                  <th>pending</th>
                  <th>status</th>
                </tr>
              </thead>
              <tbody>
          EOS
          
          html += @features.map do |feature_name, scenarios|
            info = feature_analysis(feature_name, scenarios)
            build_tr(info)
          end.join

          html += '</tbody></table>'
        end

        private

        def feature_analysis(name, scenarios)
          status_group = scenarios.group_by { |s| s.status }

          info = {
            name: name,
            scenarios: scenarios.count,
            passed: status_count(status_group["passed"]),
            failed: status_count(status_group["failed"]),
            pending: status_count(status_group["pending"])
          }
          info[:status] = info[:failed].zero? ? (info[:pending].zero? ? 'passed' : 'pending') : 'failed'

          info
        end

        def status_count(scenarios)
          scenarios.nil? ? 0 : scenarios.count
        end

        def build_tr(info)
          <<-EOS
            <tr>
              <td>#{info[:name]}</td>
              <td>#{info[:scenarios]}</td>
              <td>#{info[:passed]}</td>
              <td>#{info[:failed]}</td>
              <td>#{info[:pending]}</td>
              <td class="#{info[:status]}">#{info[:status]}</td>
            </tr>
          EOS
        end
      end
    end
  end
end
