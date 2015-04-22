require 'spec_helper'
require 'turnip_formatter/step_template/source'

describe TurnipFormatter::StepTemplate::Source do
  let(:template) do
    described_class.new
  end

  describe '#build' do
    subject { template.build(failed_example) }

    it do
      should match %r{<pre class="source">}
      should match %r{<code class="ruby">}
      should match %r{<span class="linenum">}
    end
  end
end
