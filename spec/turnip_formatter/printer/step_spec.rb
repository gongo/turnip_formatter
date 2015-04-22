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

      it {
        should match %r{<div class="step passed">}
        should match %r{<div class="step-title">}
      }
    end

    context 'has table argument' do
      let(:table) { Turnip::Table.new [] }

      let(:step) do
        step = passed_step
        allow(step).to receive(:extra_args).and_return([table])
        step
      end

      it {
        should match %r{<div class="step-body">}
        should match %r{<table class="step_outline">}
      }
    end

    context 'has outline argument' do
      let(:step) do
        passed_step
      end

      it {
        should match %r{<div class="step-body">}
        should match %r{<pre class="multiline">}
      }
    end
  end
end
