require 'spec_helper'
require 'turnip_formatter/step_template/exception'

describe TurnipFormatter::StepTemplate::Base do
  before do
    @backup_templates = TurnipFormatter.step_templates
    TurnipFormatter.step_templates.clear
  end

  after do
    @backup_templates.each do |t|
      TurnipFormatter.step_templates << t
    end
  end

  context 'register step template' do
    before do
      Class.new(described_class) do
        on_passed :build_passed
        on_failed :build_failed1
        on_failed :build_failed2
        on_pending :build_pending

        def build_passed(_)
          'build_passed'
        end

        def build_failed1(_)
          'build_failed'
        end

        def build_failed2(_)
          'hello_world'
        end

        def build_pending(_)
          'build_pending'
        end
      end
    end

    after do
      TurnipFormatter.step_templates.pop
    end

    describe '.on_passed' do
      subject do
        TurnipFormatter.step_templates_for(:passed).map do |template, method|
          template.send(method, passed_example)
        end.join
      end

      it 'returns step document for passed' do
        should eq 'build_passed'
      end
    end

    describe '.on_failed' do
      subject do
        TurnipFormatter.step_templates_for(:failed).map do |template, method|
          template.send(method, failed_example)
        end.join
      end

      it 'returns step document for failed' do
        should eq 'build_failedhello_world'
      end
    end

    describe '.on_pending' do
      subject do
        TurnipFormatter.step_templates_for(:pending).map do |template, method|
          template.send(method, pending_example)
        end.join
      end

      it 'returns step document for failed' do
        should eq 'build_pending'
      end
    end
  end
end
