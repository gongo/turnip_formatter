require 'spec_helper'

module TurnipFormatter
  class Step
    describe Failure do
      include_context 'turnip_formatter standard step parameters'
      include_context 'turnip_formatter failure scenario setup'
      include_context 'turnip_formatter standard scenario metadata'

      let(:step) do
        step = ::TurnipFormatter::Step.new(example, description)
        step.extend TurnipFormatter::Step::Failure
        step
      end

      let(:klasses) do
        builtin_klass1 = ::TurnipFormatter::StepTemplate::Source
        builtin_klass2 = ::TurnipFormatter::StepTemplate::Exception
        [builtin_klass1, builtin_klass2]
      end

      it 'exists built-in step template' do
        templates = TurnipFormatter::Step::Failure.templates
        expect(templates.keys).to include(*klasses)
      end

      context 'add custom step template' do
        let :custom_template do
          Module.new do
            def self.build(message)
              '[error] ' + message
            end
          end
        end

        before do
          TurnipFormatter::Step::Failure.add_template(custom_template) do
            example.example_group.description
          end
        end

        after do
          TurnipFormatter::Step::Failure.remove_template(custom_template)
        end

        it 'should get custom step template' do
          templates = TurnipFormatter::Step::Failure.templates
          klasses << custom_template
          expect(templates.keys).to include(*klasses)
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
