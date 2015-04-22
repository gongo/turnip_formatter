require 'spec_helper'
require 'turnip_formatter/printer/scenario'

describe TurnipFormatter::Printer::Scenario do
  let(:example) do
    passed_example
  end

  let(:scenario) do
    TurnipFormatter::Scenario::Pass.new(example)
  end

  describe '.print_out' do
    context 'with turnip example' do
      subject { described_class.print_out(scenario) }

      it { should match %r{<a .*href="##{scenario.id}"} }
      it { should match %r{<div class="scenario-title">.*Scenario: Scenario} }
      it { should match %{<ul class="tags">} }
      it { should match %{<div class="steps} }
    end

    context 'with no turnip example' do
      let(:example) do
        passed_example.tap { |e| e.metadata.delete(:turnip_formatter) }
      end

      subject { described_class.print_out(scenario) }

      it { should be nil }
    end

    context 'runtime error' do
      before do
        allow(scenario).to receive(:valid?) { raise StandardError }
        expect(TurnipFormatter::Printer::RuntimeError).to receive(:print_out)
      end

      it { described_class.print_out(scenario) }
    end
  end
end
