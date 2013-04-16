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
        let(:template_stub) do
          template.stub(:step_extra_args).and_return('extra_args')
          template.stub(:step_source).and_return('source')
          template.stub(:step_exception).and_return('exception')
          template
        end

        let(:step) do
          step = double
          step.stub(:docs).and_return(extra_args: 'a', source: 'b', exception: 'c')
          step
        end
        
        it 'should call corresponding method in step' do
          expect(template_stub.send(:step_args, step)).to eq("extra_args\nsource\nexception")
        end
      end
    end

    context 'Step has no argument' do
      describe '#step_args' do
        let(:template_stub) do
          template.should_not_receive(:step_extra_args)
          template.should_not_receive(:step_source)
          template.should_not_receive(:step_exception)
          template
        end

        let(:step) do
          step = double
          step.stub(:docs).and_return({})
          step
        end

        it 'should get null string' do
          expect(template_stub.send(:step_args, step)).to be_empty
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

      let(:extra_args_1) do
        [::Turnip::Table.new([['a']]), 'b']
      end

      let(:extra_args_2) do
        []
      end

      it 'should get string converted from extra_args' do
        expect(template_stub.send(:step_extra_args, extra_args_1)).to eq("outline\nmultiline")
        expect(template_stub.send(:step_extra_args, extra_args_2)).to be_empty
      end
    end

    describe '#step_outline' do
      let(:outline) {
        ::Turnip::Table.new([
            ["State", "Money"],
            ["<Tokushima>", "555"],
            ["<Okinawa>", "368"]
          ])
      }

      it 'should get string converted to <table>' do
        html = template.send(:step_outline, outline)
        expect(html).to match %r{<td>State</td>[[:space:]]+<td>Money</td>}
        expect(html).to match %r{<td>&lt;Tokushima&gt;</td>[[:space:]]+<td>555</td>}
        expect(html).to match %r{<td>&lt;Okinawa&gt;</td>[[:space:]]+<td>368</td>}
      end
    end

    describe '#step_multiline' do
      it 'should get escaped string enclosed in <pre>' do
        html = template.send(:step_multiline, 'a<a>a')
        expect(html).to eq('<pre>a&lt;a&gt;a</pre>')
      end
    end

    describe '#step_exception' do
      let(:exception) do
        StandardError.new('StepExceptionError').tap do |e|
          e.set_backtrace('/path/to/error.rb: 10')
        end
      end

      it 'should get string Exception class name and backtrace' do
        html = template.send(:step_exception, exception)
        expect(html).to match %r{div class="step_exception"}
        expect(html).to match %r{<pre>.*#{exception.message}.*</pre>}
        expect(html).to match %r{<li>/path/to/error.rb: 10</li>}
      end
    end
  end
end
