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
            expect(StepExtraArgs).to receive(:print_out).with(['a', table]).and_return('extra_args')
            expect(source_style).to receive(:build).with('b').and_return('source')
            expect(exception_style).to receive(:build).with('c').and_return('exception')
          end

          it { should have_tag 'div.args', text: "extra_args\nsource\nexception" }
        end
      end

      context 'custom template' do
        describe '#step_args' do
          let(:custom_template_1) do
            Module.new do
              def self.build(value)
                "<em>#{value}</em>"
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
            expect(subject).to have_tag 'div.args' do
              with_tag 'em', text: 'aiueo'
              with_tag 'strong', text: '12345'
            end
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
          expect(StepExtraArgs).not_to receive(:print_out)
          expect(source_style).not_to receive(:build)
          expect(exception_style).not_to receive(:build)
        end

        it { should have_tag 'div.args', text: '' }
      end
    end
  end
end

