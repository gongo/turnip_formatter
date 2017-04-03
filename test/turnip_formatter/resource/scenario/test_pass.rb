require 'helper'
require 'turnip_formatter/resource/scenario/pass'

module TurnipFormatter::Resource::Scenario
  class TestPass < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @resource = Pass.new(scenario_example)
    end

    def test_steps
      assert_equal(4, @resource.steps.size)
    end

    def test_id
      assert_match(/^scenario_/, @resource.id)
    end

    def test_status
      assert_equal(:passed, @resource.status)
    end

    def test_feature_info
      assert_equal('"A simple feature" in /path/to/test.feature', @resource.feature_info)
    end

    def test_run_time
      assert_equal(Float, @resource.run_time.class)
    end

    def test_backgrounds
      assert_equal(1, @resource.backgrounds.size)
      assert_equal(2, @resource.backgrounds.first.steps.size)
    end

    def test_tags
      assert_equal(['feature_tag', 'scenario_tag'], @resource.tags)
    end

    private

    def scenario_example
      @@scenario_example ||= (
        feature = feature_build(<<-EOS)

          @feature_tag
          Feature: A simple feature

            Background:
              Given there is a monster
                And I have a sword

            @scenario_tag
            Scenario: This is a simple feature
              When I attack it
              Then it should die

        EOS

        run_feature(feature, '/path/to/test.feature').first
      )
    end
  end
end
