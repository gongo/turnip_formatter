require 'spec_helper'

describe TurnipFormatter::Scenario::Pending do
  let(:example) { pending_example }
  let(:scenario) { described_class.new(example) }

  describe '#steps' do
    let(:example) do
      example = pending_example
      example.metadata[:turnip_formatter] = {
        steps: [
          create_step_node('When', 'Step 1',  1),
          create_step_node('When', 'Step 2',  3),
          create_step_node('When', 'Step 3', 10), # pending line
          create_step_node('When', 'Step 4', 11),
          create_step_node('When', 'Step 5', 12)
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
