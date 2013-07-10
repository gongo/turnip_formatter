require 'spec_helper'
require 'turnip_formatter/printer/step'

module TurnipFormatter::Printer
  describe Step do
    let(:exception_style) { ::TurnipFormatter::StepTemplate::Exception }
    let(:source_style) { ::TurnipFormatter::StepTemplate::Source }

    subject { Step.print_out(step) }

    context 'Step has arguments' do
      let(:table) { Turnip::Table.new [] }

      context 'original template' do
        describe '#step_args' do
          let(:step) do
            docs = {}
            docs[:extra_args] = { klass: nil, value: ['a', table] }
            docs[source_style] = { klass: source_style, value: 'b' }
            docs[exception_style] = { klass: exception_style, value: 'c' }

            double(status: '', name: 'step', docs: docs)
          end

          before do
            StepExtraArgs.should_receive(:print_out).with(['a', table]).and_return('extra_args')
            source_style.should_receive(:build).with('b').and_return('source')
            exception_style.should_receive(:build).with('c').and_return('exception')
          end

          it { should include "<div class=\"args\">extra_args\nsource\nexception</div>" }
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
            docs = {
              source: { klass: custom_template_1, value: 'aiueo' },
              exception: { klass: custom_template_2, value: '12345' }
            }

            double(status: '', name: 'step', docs: docs)
          end

          it 'should call corresponding method in step' do
            should include "<div class=\"args\"><html>aiueo</html>\n<strong>12345</strong></div>"
          end
        end
      end
    end

    context 'Step has no argument' do
      describe '#step_args' do
        let(:step) do
          double(status: '', name: 'step', docs: [])
        end

        before do
          StepExtraArgs.should_not_receive(:print_out)
          source_style.should_not_receive(:build)
          exception_style.should_not_receive(:build)
        end

        it { should include '<div class="args"></div>' }
      end
    end
  end
end

