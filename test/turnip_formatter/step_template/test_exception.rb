require 'helper'
require 'turnip_formatter/step_template/base'

module TurnipFormatter::StepTemplate
  class TestException < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @backup_templates = TurnipFormatter.step_templates
      TurnipFormatter.step_templates.clear

      @template = TurnipFormatter::StepTemplate::Exception.new
    end

    def teardown
      TurnipFormatter.step_templates.clear
      @backup_templates.each do |t|
        TurnipFormatter.step_templates << t
      end
    end

    def test_build_failed
      actual = @template.build_failed(dummy_failed_step)
      assert_match(%r{<div class="step_exception">}, actual)
    end

    def test_build_pending
      actual = @template.build_pending(dummy_pending_step)
      assert_match(%r{<div class="step_exception">}, actual)
      assert_match(%r{<pre>No such step}, actual)
    end
  end
end
