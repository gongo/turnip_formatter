require 'spec_helper'
require 'turnip_formatter/template/tab/speed_statistics'

module TurnipFormatter
  class Template
    module Tab
      describe SpeedStatistics do
        include_context 'turnip_formatter scenario setup'
        include_context 'turnip_formatter standard scenario metadata'

        let :passed_scenarios do
          ([example] * 3).map do |ex|
            TurnipFormatter::Scenario::Pass.new(ex)
          end.each { |s| s.stub(:run_time).and_return(rand) }
        end

        let :statistics do
          SpeedStatistics.new(passed_scenarios)
        end

        describe '.build' do
          it 'should get string as HTML table' do
            scenarios = statistics.scenarios
            html = statistics.build

            scenarios.each do |scenario|
              tag_scenario_name = "<a href=\"\##{scenario.id}\">#{scenario.name}</a>"
              tag_run_time = "<span>#{scenario.run_time}</span>"
              tag_feature_name = "<span>#{scenario.feature_name}</span>"

              expect_match = [
                '<tr>',
                "<td>#{tag_feature_name}</td>",
                "<td>#{tag_scenario_name}</td>",
                "<td>#{tag_run_time} sec</td>",
                '</tr>'
              ].join('[[:space:]]+')

              expect(html).to match %r(#{expect_match})
            end
          end
        end

        describe '#scenarios' do
          it 'should get array of scenario' do
            scenarios = statistics.scenarios
            expect(scenarios).to have(3).elements

            run_time_list = scenarios.map(&:run_time)
            expect(run_time_list.sort).to eq run_time_list
          end
        end
      end
    end
  end
end
