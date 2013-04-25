require 'spec_helper'

module TurnipFormatter
  class Step
    describe Failure do
      include_context 'turnip_formatter standard step parameters'
      include_context 'turnip_formatter scenario setup', proc {
        expect(true).to be_false
      }
      include_context 'turnip_formatter passed scenario metadata'

      let(:step) do
        step = ::TurnipFormatter::Step.new(example, description)
        step.extend TurnipFormatter::Step::Failure
        step
      end

      describe '#attention?' do
        subject { step.attention? }
        it { should be_true }
      end

      describe '#status' do
        subject { step.status }
        it { should eq :failure }
      end
    end
  end
end
