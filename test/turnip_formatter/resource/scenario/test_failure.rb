require 'helper'
require 'turnip_formatter/resource/scenario/failure'

module TurnipFormatter::Resource::Scenario
  class TestFailure < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def test_status
      @resource = Failure.new(make_scenario(<<-EOS))
        Scenario: This is a simple feature
          Then [ERROR] it should die
      EOS

      assert_equal(:failed, @resource.status)
    end

    def test_steps
      @resource = Failure.new(make_scenario(<<-EOS))
        Scenario: This is a simple feature
          When I attack it
          Then [ERROR] it should die
           And I get drop items
      EOS

      expect = [:passed, :failed, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
    end

    def test_steps_has_multiple_error
      @resource = Failure.new(make_scenario(<<-EOS))
        @aggregate_failures
        Scenario: Error in after hook
          When I attack it
          Then [ERROR] it should die
          When retry
          Then [ERROR] it should die
           And I get drop items
      EOS

      expect = [:passed, :failed, :passed, :failed, :passed]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
    end

    def test_steps_has_error_in_before_hook
      @resource = Failure.new(make_scenario(<<-EOS))
        @before_hook_error
        Scenario: Error in before hook
          When I attack it
          Then it should die
      EOS

      expect = [:failed, :unexecute, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Step::BeforeHook, @resource.steps.first.class)
    end

    def test_steps_has_error_in_after_hook
      @resource = Failure.new(make_scenario(<<-EOS))
        @after_hook_error
        Scenario: Error in after hook
          When I attack it
          Then it should die
      EOS

      expect = [:passed, :passed, :failed]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Step::AfterHook, @resource.steps.last.class)
    end

    def test_steps_has_error_in_steps_and_after_hook
      @resource = Failure.new(make_scenario(<<-EOS))
        @after_hook_error
        Scenario: Error in after hook
          When I attack it
          Then [ERROR] it should die
           And I get drop items
      EOS

      expect = [:passed, :failed, :unexecute, :failed]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
      assert_equal(TurnipFormatter::Resource::Step::AfterHook, @resource.steps.last.class)
    end

    private

    def make_scenario(scenario_text)
      feature_text = <<-EOS
        Feature: A simple feature
          #{scenario_text}
      EOS
      feature = feature_build(feature_text)
      run_feature(feature, '/path/to/test.feature').first
    end
  end
end
