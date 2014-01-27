require 'spec_helper'
require 'turnip_formatter/printer/step_extra_args'

module TurnipFormatter::Printer
  describe StepExtraArgs do
    context 'Turnip::Table' do
      describe '.print_out' do
        let(:string) do
          ::Turnip::Table.new([
              ["State", "Money"],
              ["<Tokushima>", "555"],
              ["<Okinawa>", "368"]
            ])
        end

        subject { StepExtraArgs.print_out([string]) }

        it {
          expect(subject).to have_tag 'table.step_outline' do
            with_tag 'tr:nth-child(1) td:nth-child(1)', text: 'State'
            with_tag 'tr:nth-child(1) td:nth-child(2)', text: 'Money'

            with_tag 'tr:nth-child(2) td:nth-child(1)', text: '<Tokushima>'
            with_tag 'tr:nth-child(2) td:nth-child(2)', text: '555'

            with_tag 'tr:nth-child(3) td:nth-child(1)', text: '<Okinawa>'
            with_tag 'tr:nth-child(3) td:nth-child(2)', text: '368'
          end
        }
      end
    end

    context 'String' do
      describe '.print_out' do
        let(:string) { 'a<a>a' }
        subject { StepExtraArgs.print_out([string]) }
        it { should have_tag 'pre.multiline', text: 'a<a>a' }
      end
    end
  end
end
