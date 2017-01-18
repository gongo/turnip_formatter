require 'helper'
require 'turnip_formatter/resource/scenario/failure'

module TurnipFormatter::Resource::Scenario
  class TestFailure < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def test_status
      @resource = Failure.new(scenario_example)
      assert_equal(:failed, @resource.status)
    end

    def test_steps
      @resource = Failure.new(scenario_example)

      expect = [:passed, :failed, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
    end

    def test_steps_has_error_in_before_hook
      @resource = Failure.new(scenario_error_before_hook)

      expect = [:failed, :unexecute, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Hook, @resource.steps.first.class)
    end

    def test_steps_has_error_in_after_hook
      @resource = Failure.new(scenario_error_after_hook)

      expect = [:passed, :passed, :failed]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Hook, @resource.steps.last.class)
    end

    def test_steps_has_error_in_steps_and_after_hook
      @resource = Failure.new(scenario_error_step_and_after_hook)

      expect = [:passed, :failed, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Step, @resource.steps.last.class)
    end

    private

    def scenario_example
      scenario_examples[0]
    end

    def scenario_error_before_hook
      scenario_examples[1]
    end

    def scenario_error_after_hook
      scenario_examples[2]
    end

    def scenario_error_step_and_after_hook
      scenario_examples[3]
    end

    def scenario_examples
      @@scenario_examples ||= (
        feature = feature_build(feature_text)
        run_feature(feature, '/path/to/test.feature')
      )
    end

    def feature_text
      <<-EOS
        Feature: A simple feature
          Scenario: This is a simple feature
            When I attack it
            Then [ERROR] it should die
             And I get drop items

          @before_hook_error
          Scenario: Error in before hook
            When I attack it
            Then it should die

          @after_hook_error
          Scenario: Error in after hook
            When I attack it
            Then it should die

          @after_hook_error
          Scenario: Error in after hook
            When I attack it
            Then [ERROR] it should die
             And I get drop items

      EOS
    end
  end
end
