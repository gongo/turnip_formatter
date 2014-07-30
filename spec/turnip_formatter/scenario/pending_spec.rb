require 'spec_helper'

describe TurnipFormatter::Scenario::Pending do
  let(:example) { pending_example }
  let(:scenario) { described_class.new(example) }

  describe '#valid?' do
    subject { scenario.valid? }

    context 'called by turnip example' do
      it { should be true }
    end

    context 'called by not turnip example' do
      let(:example) do
        invalid_pending_example
      end

      it { should be false }
    end
  end

  describe '#status' do
    it 'return scenario status' do
      expect(scenario.status).to eq 'pending'
    end
  end
end
