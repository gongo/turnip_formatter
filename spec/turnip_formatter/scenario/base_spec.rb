require 'spec_helper'

describe TurnipFormatter::Scenario::Base do
  let(:example) { passed_example }
  let(:scenario) { described_class.new(example) }

  describe '#valid?' do
    subject { scenario.valid? }

    context 'called by turnip example' do
      it { should be true }
    end

    context 'called by not turnip example' do
      let(:example) do
        passed_example.tap { |e| e.metadata.delete(:turnip_formatter) }
      end

      it { should be false }
    end
  end

  describe '#id' do
    it 'returns unique string' do
      expect(scenario.id).to start_with 'scenario_'
    end
  end

  describe '#steps' do
    subject { scenario.steps }

    it 'returns step array' do
      expect(subject).to be_a Array
      expect(subject[0]).to be_a TurnipFormatter::Resource::Step
    end
  end

  describe '#name' do
    it 'returns scenario name' do
      expect(scenario.name).to eq 'Scenario'
    end
  end

  describe '#status' do
    it 'returns scenario status' do
      expect(scenario.status).to eq 'passed'
    end
  end

  describe '#run_time' do
    it 'returns run time(second) of scenario' do
      expect(scenario.run_time).to be_a Float
    end
  end

  describe '#feature_info' do
    it 'returns feature name and filepath' do
      expect(scenario.feature_info).to eq '"Feature" in /path/to/hoge.feature'
    end
  end

  describe '#tags' do
    it 'returns tags' do
      expect(scenario.tags).to be_a Array
    end
  end
end
