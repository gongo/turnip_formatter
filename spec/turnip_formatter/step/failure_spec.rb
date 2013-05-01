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

      it 'exists built-in step template' do
        templates = TurnipFormatter::Step::Failure.templates
        expect(templates.keys).to eq([:source, :exception])
      end

      context 'add custom step template' do
        before do
          TurnipFormatter::Step::Failure.add_template :custom do
            example.example_group.description
          end
        end

        after do
          TurnipFormatter::Step::Failure.remove_template :custom
        end

        it 'should get custom step template' do
          templates = TurnipFormatter::Step::Failure.templates
          expect(templates.keys).to eq([:source, :exception, :custom])
        end
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
