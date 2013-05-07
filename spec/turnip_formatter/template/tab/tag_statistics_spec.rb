require 'spec_helper'
require 'turnip_formatter/template/tab/tag_statistics'

module TurnipFormatter
  class Template
    module Tab
      describe TagStatistics do
        include_context 'turnip_formatter scenario setup'
        include_context 'turnip_formatter standard scenario metadata'

        let :base_scenario do
          TurnipFormatter::Scenario::Pass.new(example)
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
          scenario.stub(:tags).and_return(['foo', 'bar'])
          scenario.stub(:status).and_return('failed')
          scenarios << scenario

          # Passed scenario no have tags
          scenario = base_scenario.dup
          scenario.stub(:tags).and_return([])
          scenario.stub(:status).and_return('passed')
          scenarios << scenario

          # Passed scenario have tags @hoge
          scenario = base_scenario.dup
          scenario.stub(:tags).and_return(['hoge'])
          scenario.stub(:status).and_return('passed')
          scenarios << scenario

          # Pending scenario have tags @fuga and @hago
          scenario = base_scenario.dup
          scenario.stub(:tags).and_return(['bar', 'hoge'])
          scenario.stub(:status).and_return('pending')
          scenarios << scenario
        end

        let :statistics do
          TagStatistics.new(scenarios)
        end

        describe '#tag_analysis' do
          let :results do
            statistics.send(:tag_analysis)
          end

          it 'should get results sort by tag name' do
            expect(results.map(&:name)).to eq ['@bar', '@foo', '@hoge', 'turnip']
          end

          it 'should get count of each status' do
            # @bar
            res = results[0]
            expect([res.passed, res.failed, res.pending]).to eq [0, 1, 1]
            expect(res.status).to eq 'failed'

            # @foo
            res = results[1]
            expect([res.passed, res.failed, res.pending]).to eq [0, 1, 0]
            expect(res.status).to eq 'failed'

            # @hoge
            res = results[2]
            expect([res.passed, res.failed, res.pending]).to eq [1, 0, 1]
            expect(res.status).to eq 'pending'

            # no tags (turnip)
            res = results[3]
            expect([res.passed, res.failed, res.pending]).to eq [1, 0, 0]
            expect(res.status).to eq 'passed'
          end
        end
      end
    end
  end
end
