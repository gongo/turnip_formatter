require 'helper'
require 'turnip_formatter/renderer/html/runtime_error'
require 'turnip_formatter/resource/scenario/pass'

module TurnipFormatter::Renderer::Html
  class TestRuntimeError < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @renderer = RuntimeError.new([exception, scenario])
    end

    def test_runtime_exception
      assert_equal(exception, @renderer.runtime_exception)
    end

    def test_scenario
      assert_equal(scenario, @renderer.scenario)
    end

    private

    def exception
      @@exception ||= Exception.new('TFERROR')
    end

    def scenario
      @@scenario ||= (
        feature = feature_build(<<-EOS)
          Feature: F
            Scenario: S
              When I attack it
        EOS

        scenario_example = run_feature(feature, '/path/to/test.feature').first
        TurnipFormatter::Resource::Scenario::Pass.new(scenario_example)
      )
    end
  end
end
