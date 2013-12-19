require 'spec_helper'
require 'turnip_formatter/printer/tab_speed_statistics'

module TurnipFormatter::Printer
  describe TabSpeedStatistics do
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter standard scenario metadata'

    let :statistics do
      TurnipFormatter::Printer::TabSpeedStatistics
    end

    let :passed_scenarios do
      ([example] * 3).map do |ex|
        TurnipFormatter::Scenario::Pass.new(ex)
      end.each { |s| allow(s).to receive(:run_time).and_return(rand) }
    end

    describe '.print_out' do
      it 'should get string as HTML table' do
        html = statistics.print_out(passed_scenarios)

        passed_scenarios.sort { |a,b| a.run_time <=> b.run_time }.each.with_index(1) do |scenario, index|
          expect(html).to have_tag "tbody tr:nth-child(#{index})" do
            with_tag 'td:nth-child(1) span', text: scenario.feature_name
            with_tag "td:nth-child(2) a[href='\##{scenario.id}']", text: scenario.name
            with_tag 'td:nth-child(3) span', text: scenario.run_time
          end
        end
      end
    end

    describe '.speed_analysis' do
      it 'should get array of scenario order by run_time' do
        scenarios = statistics.send(:speed_analysis, passed_scenarios)
        expect(scenarios.size).to eq 3

        run_time_list = scenarios.map(&:run_time)
        expect(run_time_list.sort).to eq run_time_list
      end
    end
  end
end
