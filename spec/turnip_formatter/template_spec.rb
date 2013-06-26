require 'spec_helper'

module TurnipFormatter
  describe Template do
    let(:template) { ::TurnipFormatter::Template.new }
    let(:exception_style) { ::TurnipFormatter::StepTemplate::Exception }
    let(:source_style) { ::TurnipFormatter::StepTemplate::Source }

    describe '#print_scenario_tags' do
      subject { template.print_scenario_tags(scenario) }

      context 'Step has no tag' do
        let(:scenario) do
          scenario = double('scenario')
          scenario.stub(:tags).and_return([])
          scenario
        end

        it { should eq '' }
      end

      context 'Step has tags' do
        let(:scenario) do
          scenario = double('scenario')
          scenario.stub(:tags).and_return(['hoge', '<b>fuga</b>'])
          scenario
        end

        it {
          should match %r{ul class="tags"}
          should match %r{<li>@hoge</li>[[:space:]]+<li>@&lt;b&gt;fuga&lt;/b&gt;</li>}
        }
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
      let(:table) { Turnip::Table.new [] }

      context 'original template' do
        describe '#step_args' do
          let(:step) do
            docs = {}
            docs[:extra_args] = { klass: nil, value: ['a', table] }
            docs[source_style] = { klass: source_style, value: 'b' }
            docs[exception_style] = { klass: exception_style, value: 'c' }

            step = double
            step.stub(:docs).and_return(docs)
            step
          end

          it 'should call corresponding method in step' do
            template.should_receive(:print_step_multiline).with('a').and_return('extra_args1')
            template.should_receive(:print_step_outline).with(table).and_return('extra_args2')
            source_style.should_receive(:build).with('b').and_return('source')
            exception_style.should_receive(:build).with('c').and_return('exception')
            expect(template.send(:step_args, step)).to eq("extra_args1\nextra_args2\nsource\nexception")
          end
        end
      end

      context 'custom template' do
        describe '#step_args' do
          let(:custom_template_1) do
            Module.new do
              def self.build(value)
                "<html>#{value}</html>"
              end
            end
          end

          let(:custom_template_2) do
            Module.new do
              def self.build(value)
                "<strong>#{value}</strong>"
              end
            end
          end

          let(:step) do
            step = double
            step.stub(:docs).and_return(
              source: { klass: custom_template_1, value: 'aiueo' },
              exception: { klass: custom_template_2, value: '12345' }
              )
            step
          end

          it 'should call corresponding method in step' do
            expect(template.send(:step_args, step)).to eq("<html>aiueo</html>\n<strong>12345</strong>")
          end
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
          template.should_not_receive(:print_step_multiline)
          template.should_not_receive(:print_step_outline)
          source_style.should_not_receive(:build)
          exception_style.should_not_receive(:build)
          expect(template.send(:step_args, step)).to be_empty
        end
      end
    end

    describe '#print_step_extra_args' do
      let(:template_stub) do
        template.tap do |t|
          template.stub(:print_step_outline).and_return('outline')
          template.stub(:print_step_multiline).and_return('multiline')
        end
      end

      let(:extra_args) do
        [::Turnip::Table.new([['a']]), 'b']
      end

      before do
        template.should_receive(:print_step_outline).and_return('outline')
        template.should_receive(:print_step_multiline).and_return('multiline')
      end

      it 'should get string converted from extra_args' do
        expect(template_stub.send(:print_step_extra_args, extra_args)).to eq("outline\nmultiline")
      end
    end

    describe '#print_step_multiline' do
      let(:string) { 'a<a>a' }
      subject { template.print_step_multiline(string) }
      it { should include '<pre class="multiline">a&lt;a&gt;a</pre>' }
    end

    describe '#print_step_outline' do
      let(:string) do
        ::Turnip::Table.new([
            ["State", "Money"],
            ["<Tokushima>", "555"],
            ["<Okinawa>", "368"]
          ])
      end

      subject { template.print_step_outline(string) }

      it { should match %r{<td>State</td>[[:space:]]+<td>Money</td>} }
      it { should match %r{<td>&lt;Tokushima&gt;</td>[[:space:]]+<td>555</td>} }
      it { should match %r{<td>&lt;Okinawa&gt;</td>[[:space:]]+<td>368</td>} }
    end
  end
end
