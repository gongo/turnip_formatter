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

    it do
      expect(subject).to have_tag 'div.step_exception' do
        with_tag 'pre'
        with_tag 'ol > li'
      end
    end
  end

  describe '#build_pending' do
    subject { template.build_pending(pending_example) }

    it do
      expect(subject).to have_tag 'div.step_exception' do
        with_tag 'pre', text: 'No such step(0):'
        with_tag 'ol > li'
      end
    end
  end
end
