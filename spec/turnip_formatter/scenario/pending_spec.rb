require 'spec_helper'

describe TurnipFormatter::Scenario::Pending do
  let(:example) { pending_example }
  let(:scenario) { described_class.new(example) }

  describe '#steps' do
    let(:example) do
      example = pending_example
      example.metadata[:turnip_formatter] = {
        steps: [
          Turnip::Builder::Step.new('Step 1', [],  1, 'When'),
          Turnip::Builder::Step.new('Step 2', [],  3, 'When'),
          Turnip::Builder::Step.new('Step 3', [], 10, 'When'), # pending line
          Turnip::Builder::Step.new('Step 4', [], 11, 'When'),
          Turnip::Builder::Step.new('Step 5', [], 12, 'When')
        ],
        tags: []
      }
      example
    end

    it 'should return steps that has status' do
      expect = [:passed, :passed, :pending, :unexecuted, :unexecuted]
      actual = scenario.steps.map(&:status)
      expect(actual).to eq expect
    end
  end

  describe '#valid?' do
    subject { scenario.valid? }

    context 'called by turnip example' do
      it { should be true }
    end

    context 'called by not turnip example' do
      let(:example) do
        pending_example.tap { |e| e.metadata[:line_number] = nil }
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
