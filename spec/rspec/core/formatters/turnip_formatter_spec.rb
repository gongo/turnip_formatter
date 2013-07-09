require 'spec_helper'
require 'stringio'

module RSpec::Core::Formatters
  describe TurnipFormatter do
    include_context 'turnip_formatter standard scenario metadata'

    let(:feature) { RSpec::Core::ExampleGroup.describe('Feature') }
    let(:scenario) { feature.describe('Scenario') }
    let(:output) { StringIO.new }
    let(:formatter) { TurnipFormatter.new(output) }

    describe '#example_passed' do
      before do
        scenario.example('passed', metadata) { expect(true).to be_true }
        feature.run(formatter)
      end

      it 'should get passed scenario count' do
        expect(formatter.passed_scenarios).to have(1).elements
        expect(formatter.failed_scenarios).to have(0).elements
        expect(formatter.pending_scenarios).to have(0).elements
        expect(formatter.scenarios).to have(1).elements
      end
    end

    describe '#example_failed' do
      before do
        scenario.example('failed', metadata) do
          begin
            expect(true).to be_false
          rescue => e
            e.backtrace.push ":in step:0 `"
            raise e
          end
        end
        feature.run(formatter)
      end

      it 'should get failed scenario count' do
        expect(formatter.passed_scenarios).to have(0).elements
        expect(formatter.failed_scenarios).to have(1).elements
        expect(formatter.pending_scenarios).to have(0).elements
        expect(formatter.scenarios).to have(1).elements
      end
    end

    describe '#example_pending' do
      before do
        scenario.example('pending', metadata) do
          pending("No such step(0): 'this step is unimplement'")
        end
        feature.run(formatter)
      end

      it 'should get pending scenario count' do
        expect(formatter.passed_scenarios).to have(0).elements
        expect(formatter.failed_scenarios).to have(0).elements
        expect(formatter.pending_scenarios).to have(1).elements
        expect(formatter.scenarios).to have(1).elements
      end
    end

    describe '#dump_summary' do
      before do
        formatter.dump_summary(0.0, 3, 2, 1)
      end

      subject { output.string }

      it 'should be output summary section' do
        should include '(<span id="failed_count">2</span> failed'
        should include '<span id="pending_count">1</span> pending)'
        should include '<span id="total_time">0.0</span>'
      end
    end
  end
end
