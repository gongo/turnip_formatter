require 'spec_helper'

module TurnipFormatter
  class Step
    describe Failure do
      let(:description) { ['StepName', 'Keyword', ['Docstring']] }
      let(:step) { ::TurnipFormatter::Step.new(description) }
      let(:pending_step) { step.dup.extend TurnipFormatter::Step::Pending }

      describe '#attention?' do
        subject { pending_step.attention? }
        it { should be_true }
      end

      describe '#status' do
        subject { pending_step.status }
        it { should eq 'pending' }
      end

      describe '#attention' do
        it 'should have been implemented' do
          expect(step).not_to respond_to(:attention)
          expect(pending_step).to respond_to(:attention)
        end
      end
    end
  end
end
