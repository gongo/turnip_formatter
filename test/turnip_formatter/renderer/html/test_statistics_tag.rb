require 'helper'
require 'turnip_formatter/renderer/html/statistics_tag'
require 'turnip_formatter/resource/scenario/pass'
require 'turnip_formatter/resource/scenario/failure'
require 'turnip_formatter/resource/scenario/pending'

module TurnipFormatter::Renderer::Html
  class TestStatisticsTag < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @renderer = StatisticsTag.new(scenarios)
    end

    def test_results
      ta = @renderer.results[0]
      assert_equal(['@bar', 2, 1, 1, 0, :failed], actual(ta))

      tb = @renderer.results[1]
      assert_equal(['@baz', 2, 1, 0, 1, :pending], actual(tb))

      tc = @renderer.results[2]
      assert_equal(['@foo', 2, 2, 0, 0, :passed], actual(tc))

      td = @renderer.results[3]
      assert_equal(['no_tag', 1, 1, 0, 0, :passed], actual(td))
    end

    private

    def actual(f)
      [f.name, f.scenario_count, f.passed_count, f.failed_count, f.pending_count, f.status]
    end

    #
    #  name  | scenario | passed | failed | pending | result
    # ------ | -------- | ------ | ------ | ------- | -------
    #  @bar  |        2 |      1 |      1 |       0 | failed
    #  @baz  |        2 |      1 |      0 |       1 | pending
    #  @foo  |        2 |      2 |      0 |       0 | passed
    # no_tag |        1 |      1 |      0 |       0 | passed
    #
    def scenarios
      @@scenarios ||= (
        ss = []

        feature = feature_build(feature_a)
        examples = run_feature(feature, '/path/to/test1.feature')
        ss << TurnipFormatter::Resource::Scenario::Pass.new(examples[0])
        ss << TurnipFormatter::Resource::Scenario::Failure.new(examples[1])

        feature = feature_build(feature_b)
        examples = run_feature(feature, '/path/to/test2.feature')
        ss << TurnipFormatter::Resource::Scenario::Pending.new(examples[0])

        feature = feature_build(feature_c)
        examples = run_feature(feature, '/path/to/test3.feature')
        ss << TurnipFormatter::Resource::Scenario::Pass.new(examples[0])
        ss << TurnipFormatter::Resource::Scenario::Pass.new(examples[1])

        ss
      )
    end

    def feature_a
      <<-EOS
      Feature: A

        Scenario: Pass Scenario
          When A
          Then B
           And C

        @bar
        Scenario: Failure Scenario
          When A
          Then [ERROR] B
           And C
      EOS
    end

    def feature_b
      <<-EOS
      @baz
      Feature: B
        Scenario: Pending Scenario
          When A
          Then [PENDING] B
           And C
      EOS
    end

    def feature_c
      <<-EOS
      @foo
      Feature: C

        @bar
        Scenario: Pass Scenario 1
          When A
          Then B
           And C

        @baz
        Scenario: Pass Scenario 2
          When A
          Then B
           And C
      EOS
    end
  end
end
