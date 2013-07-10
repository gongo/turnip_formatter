require 'spec_helper'
require 'turnip_formatter/printer/tab_feature_statistics'

module TurnipFormatter::Printer
  describe TabFeatureStatistics do
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter standard scenario metadata'

    let :base_scenario do
      TurnipFormatter::Scenario::Pass.new(example)
    end

    let :statistics do
      TurnipFormatter::Printer::TabFeatureStatistics
    end

    context 'feature only passed scenario' do
      let :scenarios do
        # Feature: Hago (passed:2 failed:0, pending:0)
        ['passed', 'passed'].map do |status|
          scenario = base_scenario.dup
          scenario.stub(:status).and_return(status)
          scenario
        end
      end

      describe '.feature_analysis' do
        it 'should get passed feature information' do
          info = statistics.send(:feature_analysis, 'Hoge', scenarios)
          expect(info.name).to eq 'Hoge'
          expect(info.passed).to eq 2
          expect(info.failed).to be_zero
          expect(info.pending).to be_zero
          expect(info.status).to eq 'passed'
        end
      end
    end

    context 'feature with failed scenario' do
      let :scenarios do
        # Feature: Hoge (passed:1 failed:2, pending:0)
        ['passed', 'failed', 'failed'].map do |status|
          scenario = base_scenario.dup
          scenario.stub(:status).and_return(status)
          scenario
        end
      end

      describe '.feature_analysis' do
        it 'should get failed feature information' do
          info = statistics.send(:feature_analysis, 'Fuga', scenarios)
          expect(info.name).to eq 'Fuga'
          expect(info.passed).to eq 1
          expect(info.failed).to eq 2
          expect(info.pending).to be_zero
          expect(info.status).to eq 'failed'
        end
      end
    end

    context 'feature with pending scenario' do
      let :scenarios do
        # Feature: Fuga (passed:1 failed:0, pending:1)
        ['passed', 'pending'].map do |status|
          scenario = base_scenario.dup
          scenario.stub(:status).and_return(status)
          scenario
        end
      end

      describe '.feature_analysis' do
        it 'should get pending feature information' do
          info = statistics.send(:feature_analysis, 'Hago', scenarios)
          expect(info.name).to eq 'Hago'
          expect(info.passed).to eq 1
          expect(info.failed).to be_zero
          expect(info.pending).to eq 1
          expect(info.status).to eq 'pending'
        end
      end
    end
  end
end
