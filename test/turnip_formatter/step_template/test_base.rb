require 'helper'
require 'turnip_formatter/step_template/base'

module TurnipFormatter::StepTemplate
  class TestBase < Test::Unit::TestCase
    def setup
      @backup_templates = TurnipFormatter.step_templates
      TurnipFormatter.step_templates.clear

      Class.new(TurnipFormatter::StepTemplate::Base) do
        on_passed :build_passed
        on_failed :build_failed1
        on_failed :build_failed2
        on_pending :build_pending

        def build_passed(_)  ; 'build_passed'  ; end
        def build_failed1(_) ; 'build_failed'  ; end
        def build_failed2(_) ; 'hello_world'   ; end
        def build_pending(_) ; 'build_pending' ; end
      end
    end

    def teardown
      TurnipFormatter.step_templates.clear
      @backup_templates.each do |t|
        TurnipFormatter.step_templates << t
      end
    end

    def test_on_passed
      text = TurnipFormatter.step_templates_for(:passed).map do |t, m|
        t.send(m, nil)
      end.join

      assert_equal('build_passed', text)
    end

    def test_on_failed
      text = TurnipFormatter.step_templates_for(:failed).map do |t, m|
        t.send(m, nil)
      end.join

      assert_equal('build_failedhello_world', text)
    end

    def test_on_pending
      text = TurnipFormatter.step_templates_for(:pending).map do |t, m|
        t.send(m, nil)
      end.join

      assert_equal('build_pending', text)
    end
  end
end
