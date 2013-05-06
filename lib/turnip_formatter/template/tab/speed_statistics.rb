# -*- coding: utf-8 -*-

require 'turnip_formatter/template'
require 'ostruct'

module TurnipFormatter
  class Template
    module Tab
      class SpeedStatistics
        attr_reader :scenarios

        #
        # @param [Array]  passed_examples  Array of TurnipFormatter::Scenario::Pass
        #
        def initialize(passed_scenarios)
          @scenarios = passed_scenarios.map do |s|
            OpenStruct.new(
              {
                id: s.id,
                feature_name: s.feature_name,
                name: s.name,
                run_time: s.run_time
              }
            )
          end.sort { |a, b| a.run_time <=> b.run_time }
        end

        def build
          html = <<-EOS
            <table>
              <thead>
                <tr>
                  <th>Feature</th>
                  <th>Scenario</th>
                  <th>Duration</th>
                </tr>
              </thead>
              <tbody>
          EOS

          html += scenarios.map do |scenario|
            <<-EOS
                <tr>
                  <td><span>#{scenario.feature_name}</span></td>
                  <td><a href=\"\##{scenario.id}\">#{scenario.name}</a></td>
                  <td><span>#{scenario.run_time}</span> sec</td>
                </tr>
            EOS
          end.join

          html += <<-EOS
              </tbody>
            </table>
          EOS

          html
        end
      end
    end
  end
end
