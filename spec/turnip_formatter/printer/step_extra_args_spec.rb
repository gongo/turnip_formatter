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

        subject { StepExtraArgs.print_out(string) }

        it { should match %r{<td>State</td>[[:space:]]*<td>Money</td>} }
        it { should match %r{<td>&lt;Tokushima&gt;</td>[[:space:]]*<td>555</td>} }
        it { should match %r{<td>&lt;Okinawa&gt;</td>[[:space:]]*<td>368</td>} }
      end
    end

    context 'String' do
      describe '.print_out' do
        let(:string) { 'a<a>a' }
        subject { StepExtraArgs.print_out(string) }
        it { should match %r{<pre class="step_doc_string">a&lt;a&gt;a</pre>} }
      end
    end
  end
end
