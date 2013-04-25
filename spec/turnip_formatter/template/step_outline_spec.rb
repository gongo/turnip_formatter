require 'spec_helper'
require 'turnip/table'
require 'turnip_formatter/template/step_outline'

module TurnipFormatter
  class Template
    describe StepOutline do
      let(:template) { ::TurnipFormatter::Template::StepOutline }

      let(:string) do
        ::Turnip::Table.new([
            ["State", "Money"],
            ["<Tokushima>", "555"],
            ["<Okinawa>", "368"]
          ])
      end

      describe '.build' do
        subject { template.build(string) }

        it do
          should match %r{<td>State</td>[[:space:]]+<td>Money</td>}
          should match %r{<td>&lt;Tokushima&gt;</td>[[:space:]]+<td>555</td>}
          should match %r{<td>&lt;Okinawa&gt;</td>[[:space:]]+<td>368</td>}
        end
      end
    end
  end
end
