require 'spec_helper'

module TurnipFormatter
  class Step
    describe Failure do
      include_context 'turnip_formatter standard step parameters'
      include_context 'turnip_formatter pending scenario setup'
      include_context 'turnip_formatter standard scenario metadata'

      let(:step) do
        step = ::TurnipFormatter::Step.new(example, description)
        step.extend TurnipFormatter::Step::Pending
        step
      end

      let(:klasses) do
        builtin_klass = ::TurnipFormatter::StepTemplate::Exception
        [builtin_klass]
      end

      it 'exists built-in step template' do
        templates = TurnipFormatter::Step::Pending.templates
        expect(templates.keys).to include(*klasses)
      end

      context 'add custom step template' do
        let :custom_template do
          Module.new do
            def self.build(message)
              '[pending] ' + message
            end
          end
        end

        before do
          TurnipFormatter::Step::Pending.add_template custom_template do
            example.example_group.description
          end
        end

        after do
          TurnipFormatter::Step::Failure.remove_template custom_template
        end

        it 'should get custom step template' do
          templates = TurnipFormatter::Step::Pending.templates
          klasses << custom_template
          expect(templates.keys).to include(*klasses)
        end
      end

      describe '#attention?' do
        subject { step.attention? }
        it { should be true }
      end

      describe '#status' do
        subject { step.status }
        it { should eq :pending }
      end
    end
  end
end
