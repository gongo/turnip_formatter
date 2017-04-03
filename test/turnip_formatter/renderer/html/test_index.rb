require 'helper'
require 'turnip_formatter/renderer/html/index'
require 'turnip_formatter/resource/scenario/pass'
require 'turnip_formatter/resource/scenario/failure'
require 'turnip_formatter/resource/scenario/pending'

module TurnipFormatter::Renderer::Html
  class TestIndex < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @renderer = Index.new(index_params)
    end

    def test_style_links
      assert_equal(String, @renderer.style_links.class)
    end

    def test_style_codes
      assert_equal(String, @renderer.style_codes.class)
    end

    def test_script_links
      assert_equal(String, @renderer.script_links.class)
    end

    def test_script_codes
      assert_equal(String, @renderer.script_codes.class)
    end

    def test_title
      mock(TurnipFormatter::Renderer::Html).project_name { 'Perfect Turnip' }
      assert_equal('Perfect Turnip report', @renderer.title)
    end

    def test_scenarios_html
      assert_equal(String, @renderer.scenarios_html.class)
    end

    def test_statistics_feature_html
      assert_equal(String, @renderer.statistics_feature_html.class)
    end

    def test_statistics_tag_html
      assert_equal(String, @renderer.statistics_tag_html.class)
    end

    def test_statistics_speed_html
      assert_equal(String, @renderer.statistics_speed_html.class)
    end

    def test_result_status
      assert_equal('3 Scenario (1 failed 1 pending)', @renderer.result_status)
    end

    def test_total_time
      assert_equal("20.0", @renderer.total_time)
    end

    def test_turnip_version
      assert_equal(Turnip::VERSION, @renderer.turnip_version)
    end

    private

    def index_params
      {
        scenarios: scenarios,
        failed_count: 1,
        pending_count: 1,
        total_time: 20.0
      }
    end

    def scenarios
      @@scenarios ||= (
        ss = []

        feature = feature_build(feature_text)
        examples = run_feature(feature, '/path/to/test1.feature')
        ss << TurnipFormatter::Resource::Scenario::Pass.new(examples[0])
        ss << TurnipFormatter::Resource::Scenario::Failure.new(examples[1])
        ss << TurnipFormatter::Resource::Scenario::Pending.new(examples[2])
        ss
      )
    end

    def feature_text
      <<-EOS
      Feature: Feature
        Scenario: Pass Scenario
          When A

        Scenario: Failure Scenario
          When [ERROR] B

        Scenario: Pending Scenario
          When [PENDING] C
      EOS
    end
  end
end
