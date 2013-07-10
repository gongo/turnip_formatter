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

        it { should include "<a href=\"##{scenario.id}\">" } # scenario.id
        it { should include 'Scenario: Scenario' } # h(scenario.name)
      end
    end

    context 'not turnip example' do
      describe '.print_out' do
        before do
          scenario.stub(:validation) { raise NoFeatureFileError }
          RuntimeError.should_receive(:print_out)
        end

        it { Scenario.print_out(scenario) }
      end
    end
  end
end
