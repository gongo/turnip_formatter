require 'spec_helper'

module TurnipFormatter
  describe Step do
    include_context 'turnip_formatter standard step parameters'
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter passed scenario metadata'
    let(:step) { ::TurnipFormatter::Step.new(example, description) }

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
  end
end
