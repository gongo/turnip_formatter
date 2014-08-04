require 'spec_helper'
require 'turnip_formatter/html/printer/step'

describe TurnipFormatter::Html::Printer::Step do
  describe '.print_out' do
    subject { described_class.print_out(step) }

    context 'not has extra argument' do
      let(:step) do
        step = passed_step
        expect(step).to receive(:extra_args).and_return([])
        step
      end

      it do
        should have_tag 'div.step' do
          with_tag 'div.step-title'
        end
      end
    end

    context 'has table argument' do
      let(:table) { Turnip::Table.new [] }

      let(:step) do
        step = passed_step
        allow(step).to receive(:extra_args).and_return([table])
        step
      end

      it do
        should have_tag 'div.step' do
          with_tag 'div.step-title'
          with_tag 'div.step-body' do
            with_tag 'table.step_outline'
          end
        end
      end
    end

    context 'has outline argument' do
      let(:step) do
        passed_step
      end

      it do
        should have_tag 'div.step' do
          with_tag 'div.step-title'
          with_tag 'div.step-body' do
            with_tag 'table.multiline'
          end
        end
      end
    end
  end
end
