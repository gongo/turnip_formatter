require 'spec_helper'

module TurnipFormatter
  describe Step do
    let(:step) { ::TurnipFormatter::Step.new(description) }
    let(:description) { ['StepName', 'Keyword', ['Docstring']] }

    describe '#attention?' do
      subject { step.attention? }
      it { should be_false }
    end

    describe '#name' do
      subject { step.name }
      it { should eq('KeywordStepName') }
    end

    describe '#docs' do
      subject { step.docs }
      it { should include :extra_args }
    end

    context 'No docstring' do
      let(:description) { ['StepName', 'Keyword', []] }

      describe '#docs' do
        subject { step.docs }
        it { should_not include :extra_args }
      end      
    end
  end
end
