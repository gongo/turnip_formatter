require 'spec_helper'

describe TurnipFormatter::Scenario::Failure do
  let(:example) { failed_example }
  let(:scenario) { described_class.new(example) }

  describe '#steps' do
    let(:example) do
      example = failed_example
      example.metadata[:turnip_formatter] = {
        steps: [
          create_step_node('When', 'Step 1',  1),
          create_step_node('When', 'Step 2',  3),
          create_step_node('When', 'Step 3', 10), # failed line
          create_step_node('When', 'Step 4', 11),
          create_step_node('When', 'Step 5', 12)
        ],
        tags: []
      }
      example
    end

    it 'should return steps that has status' do
      expect = [:passed, :passed, :failed, :unexecuted, :unexecuted]
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
        backtrace = failed_example.exception.backtrace.reject do |b|
          b.include? failed_example.metadata[:file_path]
        end

        failed_example.tap { |e| e.exception.set_backtrace(backtrace) }
      end

      it { should be false }
    end
  end

  describe '#status' do
    it 'return scenario status' do
      expect(scenario.status).to eq 'failed'
    end
  end
end
