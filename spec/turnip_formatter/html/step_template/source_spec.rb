require 'spec_helper'
require 'turnip_formatter/html/step_template/source'

describe TurnipFormatter::Html::StepTemplate::Source do
  let(:template) do
    described_class.new
  end

  describe '#build' do
    subject { template.build(failed_example) }

    it do
      expect(subject).to have_tag 'pre.source > code.ruby' do
        with_tag 'span.linenum'
      end
    end
  end
end
