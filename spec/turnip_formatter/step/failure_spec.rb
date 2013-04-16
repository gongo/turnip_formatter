require 'spec_helper'

module TurnipFormatter
  class Step
    describe Failure do
      let(:description) { ['StepName', 'Keyword', ['Docstring']] }
      let(:step) { ::TurnipFormatter::Step.new(description) }
      let(:failure_step) { step.dup.extend TurnipFormatter::Step::Failure }      

      describe '#attention?' do
        subject { failure_step.attention? }
        it { should be_true }
      end

      describe '#status' do
        subject { failure_step.status }
        it { should eq 'failure' }
      end

      describe '#attention' do
        it 'should have been implemented' do
          expect(step).not_to respond_to(:attention)
          expect(failure_step).to respond_to(:attention)
        end

        it 'should set exception informaton' do
          exception = StandardError.new
          expect(exception.backtrace).to be_nil

          failure_step.attention(exception, ['/path/to/error.rb: 10'])

          expect(failure_step.docs[:source]).to eq '/path/to/error.rb: 10'
          failure_step.docs[:exception].tap do |e|
            expect(e).to eql(exception)
            expect(e.backtrace.first).to eq '/path/to/error.rb: 10'
          end
        end
      end
    end
  end
end
