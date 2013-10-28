require 'spec_helper'
require 'turnip_formatter/printer/index'

module TurnipFormatter::Printer
  describe Index do

    let(:formatter) do
      double("Formatter", {
          :scenarios        => [],
          :passed_scenarios => [],
          :failure_count    => 0,
          :pending_count    => 0,
          :duration         => 0
        })
    end

    describe '.print_out' do
      subject { Index.print_out(formatter) }

      it { should have_tag 'h1', text: 'Turnip Report' }
    end

    context 'project_name is changed' do
      before do
        @original_project_name = RSpec.configuration.project_name
        RSpec.configuration.project_name = 'My Project'
      end

      describe '.print_out' do
        subject { Index.print_out(formatter) }

        it { should have_tag 'h1', text: 'My Project Report' }
      end

      after do
        RSpec.configuration.project_name = @original_project_name
      end
    end
  end
end
