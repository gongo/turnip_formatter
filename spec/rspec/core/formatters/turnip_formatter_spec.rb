require 'spec_helper'
require 'stringio'

module RSpec::Core::Formatters
  describe TurnipFormatter do
    let(:feature) { RSpec::Core::ExampleGroup.describe('Feature') }
    let(:scenario) { feature.describe('Scenario') }

    let(:scenario_metadata) do
      {
        steps: { descriptions: [], docstrings: [[]], keywords: ['When'], tags: [] },
        file_path: '/path/to/hoge.feature'
      }
    end

    let(:output) { StringIO.new }
    let(:formatter) { TurnipFormatter.new(output) }

    describe '#start' do
      it 'should be output header section' do
        formatter.start(0)
        expect(output.string).to match '<!DOCTYPE html>'
        expect(output.string).to match '<div id="main" role="main">'
      end
    end

    describe '#example_passed' do
      it 'should be output passed scenario section' do
        scenario.example('passed', scenario_metadata) { expect(true).to be_true }
        feature.run(formatter)

        string = output.string
        expect(string).to match 'class="scenario passed"'
      end
    end

    describe '#example_failed' do
      let(:failed_metadata) do
        scenario_metadata.dup.tap do |metadata|
          metadata[:steps][:descriptions] << 'this step is error'
          metadata[:steps][:docstrings] << []
          metadata[:steps][:keywords] << 'Given'
        end
      end

      it 'should be output failed scenario section' do
        scenario.example('failed', failed_metadata) do
          begin
            expect(true).to be_false
          rescue => e
            e.backtrace.push ":in step:0 `"
            raise e
          end
        end
        feature.run(formatter)
        expect(output.string).to match 'class="scenario failed"'
      end
    end

    describe '#example_pending' do
      let(:pending_metadata) do
        scenario_metadata.dup.tap do |metadata|
          metadata[:steps][:descriptions] << 'this step is unimplement'
          metadata[:steps][:docstrings] << []
          metadata[:steps][:keywords] << 'Given'
        end
      end

      it 'should be output pending scenario section' do
        scenario.example('pending', pending_metadata) do
          pending("No such step(0): 'this step is unimplement'")
        end
        feature.run(formatter)

        expect(output.string).to match 'class="scenario pending"'
      end

      it 'should be output runtime exception section' do
        scenario.example('pending', pending_metadata) do
          pending("Pending")
        end
        feature.run(formatter)

        expect(output.string).to match 'class="exception"'
      end
    end

    describe '#dump_summary' do
      it 'should be output summary section' do
        formatter.dump_summary(0.0, 3, 2, 1)
        actual = output.string

        expect(actual).to match %r{getElementById\("total_count"\).innerHTML = "3";}
        expect(actual).to match %r{getElementById\("failed_count"\).innerHTML = "2";}
        expect(actual).to match %r{getElementById\("pending_count"\).innerHTML = "1";}
        expect(actual).to match %r{getElementById\("total_time"\).innerHTML = "0.0";}
        expect(actual).to match '</html>'
      end
    end
  end
end
