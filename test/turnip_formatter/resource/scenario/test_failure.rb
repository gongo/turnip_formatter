require 'helper'
require 'turnip_formatter/resource/scenario/failure'

module TurnipFormatter::Resource::Scenario
  class TestFailure < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @resource = Failure.new(scenario_example)
    end

    def test_status
      assert_equal(:failed, @resource.status)
    end

    def test_steps
      expect = [:passed, :failed, :unexecute]
      actual = @resource.steps.map(&:status)

      assert_equal(expect, actual)
    end

    private

    def scenario_example
      @@scenario_example ||= (
        feature = feature_build(<<-EOS)
          Feature: A simple feature
            Scenario: This is a simple feature
              When I attack it
              Then [ERROR] it should die
               And I get drop items
        EOS

        run_feature(feature, '/path/to/test.feature').first
      )
    end
  end
end
