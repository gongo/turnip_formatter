require 'spec_helper'
require 'turnip_formatter/printer/step'

describe TurnipFormatter::Printer::Step do
  describe '.print_out' do
    subject { described_class.print_out(step) }

    context 'not has extra argument' do
      let(:step) do
        step = passed_step
        expect(step).to receive(:extra_args).and_return([])
        step
      end

      it do
        should have_tag 'li.step'
        should have_tag 'div.args'
      end
    end

    context 'has table argument' do
      let(:table) { Turnip::Table.new [] }

      let(:step) do
        step = passed_step
        expect(step).to receive(:extra_args).and_return([table])
        step
      end

      it do
        should have_tag 'li.step'
        should have_tag 'div.args'
        should have_tag 'table.step_outline'
      end
    end


    context 'has outline argument' do
      let(:step) do
        passed_step
      end

      it do
        should have_tag 'li.step'
        should have_tag 'div.args'
        should have_tag 'pre.multiline'
      end
    end
  end
end
