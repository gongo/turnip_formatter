require 'helper'
require 'turnip_formatter/resource/scenario/pending'

module TurnipFormatter::Resource::Scenario
  class TestPending < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @resource = Pending.new(scenario_example)
    end

    def test_status
      assert_equal(:pending, @resource.status)
    end

    def test_steps
      expect = [:passed, :pending, :unexecute]
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
              Then [PENDING] it should die
               And I get drop items
        EOS

        run_feature(feature, '/path/to/test.feature').first
      )
    end
  end
end
