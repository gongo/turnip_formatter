require 'spec_helper'
require 'turnip_formatter/step_template/exception'

describe TurnipFormatter::StepTemplate::Exception do
  after do
    TurnipFormatter.step_templates.pop
  end

  let!(:template) do
    described_class.new
  end

  describe '#build_failed' do
    subject { template.build_failed(failed_example) }

    it { should match %r{<div class="step_exception">} }
  end

  describe '#build_pending' do
    subject { template.build_pending(pending_example) }

    it { should match %r{<div class="step_exception">} }
    it { should match %r{<pre>No such step} }
  end
end
