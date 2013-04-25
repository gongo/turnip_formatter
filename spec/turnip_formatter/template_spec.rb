require 'spec_helper'

module TurnipFormatter
  describe Template do
    let(:template) { ::TurnipFormatter::Template.new }

    context 'Step has no tag' do
      describe '#scenario_tags' do
        let(:scenario) do
          scenario = double('scenario')
          scenario.stub(:tags).and_return([])
          scenario
        end
        
        it 'should get null string' do
          expect(template.send(:scenario_tags, scenario)).to be_empty
        end
      end
    end

    context 'Step has tags' do
      describe '#scenario_tags' do
        let(:scenario) do
          scenario = double('scenario')
          scenario.stub(:tags).and_return(['hoge', 'fuga'])
          scenario
        end
        
        it 'should get null string' do
          html = template.send(:scenario_tags, scenario)
          expect(html).to match %r{ul class="tags"}
          expect(html).to match %r{<li>@hoge</li>[[:space:]]+<li>@fuga</li>}
        end
      end
    end

    describe '#step_attr' do
      let(:passed_step) do
        step = double
        step.stub(:attention?).and_return(false)
        step.should_not_receive(:status)
        step
      end

      let(:failed_step) do
        step = double
        step.stub(:attention?).and_return(true)
        step.should_receive(:status) { 'failed' }
        step
      end

      it 'should get tag attribute string' do
        expect(template.send(:step_attr, passed_step)).to eq('class="step"')
        expect(template.send(:step_attr, failed_step)).to eq('class="step failed"')
      end
    end
    
    context 'Step has arguments' do
      describe '#step_args' do
        let(:table) { Turnip::Table.new [] }

        let(:step) do
          step = double
          step.stub(:docs).and_return(
            extra_args: ['a', table], source: 'b', exception: 'c'
          )
          step
        end
        
        it 'should call corresponding method in step' do
          Template::StepMultiline.should_receive(:build).with('a').and_return('extra_args1')
          Template::StepOutline.should_receive(:build).with(table).and_return('extra_args2')
          Template::StepSource.should_receive(:build).with('b').and_return('source')
          Template::StepException.should_receive(:build).with('c').and_return('exception')

          expect(template.send(:step_args, step)).to eq("extra_args1\nextra_args2\nsource\nexception")
        end
      end
    end

    context 'Step has no argument' do
      describe '#step_args' do
        let(:step) do
          step = double
          step.stub(:docs).and_return({})
          step
        end

        it 'should get null string' do
          Template::StepOutline.should_not_receive(:build)
          Template::StepMultiline.should_not_receive(:build)
          Template::StepSource.should_not_receive(:build)
          Template::StepException.should_not_receive(:build)

          expect(template.send(:step_args, step)).to be_empty
        end
      end
    end

    describe '#step_extra_args' do
      let(:template_stub) do
        template.tap do |t|
          template.stub(:step_outline).and_return('outline')
          template.stub(:step_multiline).and_return('multiline')
        end
      end

      let(:extra_args) do
        [::Turnip::Table.new([['a']]), 'b']
      end

      before do
        Template::StepOutline.should_receive(:build).and_return('outline')
        Template::StepMultiline.should_receive(:build).and_return('multiline')
      end

      it 'should get string converted from extra_args' do
        expect(template_stub.send(:step_extra_args, extra_args)).to eq("outline\nmultiline")
      end
    end
  end
end
