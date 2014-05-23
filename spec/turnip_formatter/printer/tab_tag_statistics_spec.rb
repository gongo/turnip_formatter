require 'spec_helper'
require 'turnip_formatter/printer/tab_tag_statistics'

module TurnipFormatter::Printer
  describe TabTagStatistics do
    let :base_scenario do
      TurnipFormatter::Scenario::Pass.new(passed_example)
    end

    let :scenarios do
      scenarios = []

      # | tag   | scenarios | passed | failed | pending | status  |
      # |-------+-----------+--------+--------+---------+---------|
      # | none  |         1 |      1 |      0 |       0 | status  |
      # | @bar  |         2 |      0 |      1 |       1 | failed  |
      # | @foo  |         1 |      0 |      1 |       0 | failed  |
      # | @hoge |         1 |      1 |      0 |       1 | pending |

      # Failed scenario have tags @hoge and @fuga
      scenario = base_scenario.dup
      allow(scenario).to receive(:tags).and_return(['foo', 'bar'])
      allow(scenario).to receive(:validation).and_return(true)
      allow(scenario).to receive(:status).and_return('failed')
      scenarios << scenario

      # Passed scenario no have tags
      scenario = base_scenario.dup
      allow(scenario).to receive(:tags).and_return([])
      allow(scenario).to receive(:validation).and_return(true)
      allow(scenario).to receive(:status).and_return('passed')
      scenarios << scenario

      # Passed scenario have tags @hoge
      scenario = base_scenario.dup
      allow(scenario).to receive(:tags).and_return(['hoge'])
      allow(scenario).to receive(:validation).and_return(true)
      allow(scenario).to receive(:status).and_return('passed')
      scenarios << scenario

      # Pending scenario have tags @fuga and @hago
      scenario = base_scenario.dup
      allow(scenario).to receive(:tags).and_return(['bar', 'hoge'])
      allow(scenario).to receive(:validation).and_return(true)
      allow(scenario).to receive(:status).and_return('pending')
      scenarios << scenario
    end

    let :statistics do
      TurnipFormatter::Printer::TabTagStatistics
    end

    let :groups do
      statistics.send(:group_by_tag, scenarios)
    end

    describe '.group_by_tag' do
      it 'should get results sort by tag name' do
        expect(groups.map(&:first)).to eq ['@bar', '@foo', '@hoge', 'turnip']
      end
    end

    describe '.tag_analysis' do
      it 'should get count of each status' do
        # @bar
        group = groups[0]
        statistics.send(:tag_analysis, group[0], group[1]).tap do |result|
          expect(result.passed_count).to eq 0
          expect(result.failed_count).to eq 1
          expect(result.pending_count).to eq 1
          expect(result.status).to eq 'failed'
        end

        # @foo
        group = groups[1]
        statistics.send(:tag_analysis, group[0], group[1]).tap do |result|
          expect(result.passed_count).to eq 0
          expect(result.failed_count).to eq 1
          expect(result.pending_count).to eq 0
          expect(result.status).to eq 'failed'
        end

        # @hoge
        group = groups[2]
        statistics.send(:tag_analysis, group[0], group[1]).tap do |result|
          expect(result.passed_count).to eq 1
          expect(result.failed_count).to eq 0
          expect(result.pending_count).to eq 1
          expect(result.status).to eq 'pending'
        end

        # no tags (turnip)
        group = groups[3]
        statistics.send(:tag_analysis, group[0], group[1]).tap do |result|
          expect(result.passed_count).to eq 1
          expect(result.failed_count).to eq 0
          expect(result.pending_count).to eq 0
          expect(result.status).to eq 'passed'
        end
      end
    end
  end
end
