require 'spec_helper'
require 'turnip_formatter/printer/scenario'

module TurnipFormatter::Printer
  describe Scenario do
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter standard scenario metadata'

    let(:scenario) do
      TurnipFormatter::Scenario::Pass.new(example)
    end

    context 'turnip example' do
      describe '.print_out' do
        subject { Scenario.print_out(scenario) }

        it { should have_tag 'a', with: { href: '#' + scenario.id } }
        it { should have_tag 'span.scenario_name', text: /Scenario: Scenario/ }
        it { should have_tag 'span.feature_name' }
        it { should have_tag 'ul.tags' }
        it { should have_tag 'ul.steps' }
      end
    end

    context 'not turnip example' do
      describe '.print_out' do
        before do
          allow(scenario).to receive(:validation) { raise NoFeatureFileError }
          expect(RuntimeError).to receive(:print_out)
        end

        it { Scenario.print_out(scenario) }
      end
    end
  end
end
