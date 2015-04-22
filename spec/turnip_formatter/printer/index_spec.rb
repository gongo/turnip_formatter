require 'spec_helper'
require 'turnip_formatter/printer/index'

module TurnipFormatter::Printer
  describe Index do

    let(:formatter) do
      {
        scenarios:      [],
        scenario_files: [],
        failed_count:   0,
        pending_count:  0,
        duration:       0
      }
    end

    subject { Index.print_out(formatter) }

    describe '.print_out' do
      it { should match %r{<h1>Turnip Report</h1>} }
    end

    context 'project_name is changed' do
      before do
        @original_project_name = TurnipFormatter.configuration.title
        TurnipFormatter.configuration.title = 'My Project'
      end

      describe '.print_out' do
        it { should match %r{<h1>My Project Report</h1>} }
      end

      after do
        TurnipFormatter.configuration.title = @original_project_name
      end
    end
  end
end
