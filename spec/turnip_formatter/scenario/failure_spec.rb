require 'spec_helper'

describe TurnipFormatter::Scenario::Failure do
  let(:example) { failed_example }
  let(:scenario) { described_class.new(example) }

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
