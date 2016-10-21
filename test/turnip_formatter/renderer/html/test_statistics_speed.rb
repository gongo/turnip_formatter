require 'helper'
require 'test/unit/rr'
require 'turnip_formatter/renderer/html/statistics_speed'
require 'turnip_formatter/resource/scenario/pass'
require 'turnip_formatter/resource/scenario/failure'
require 'turnip_formatter/resource/scenario/pending'

module TurnipFormatter::Renderer::Html
  class TestStatisticsSpeed < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    def setup
      @renderer = StatisticsSpeed.new(scenarios)
    end

    def test_results
      results = @renderer.results

      assert_equal(3, results.size)
      assert_equal(['B',  3.0], [results[0].name, results[0].run_time])
      assert_equal(['E',  4.0], [results[1].name, results[1].run_time])
      assert_equal(['A', 10.0], [results[2].name, results[2].run_time])
    end

    private

    #
    # name | duration | in ranking
    # ---- | -------- | ----------
    #    C |      1.0 | false (failed)
    #    B |      3.0 | true
    #    E |      4.0 | true
    #    D |      5.0 | false (pending)
    #    A |     10.0 | true
    #
    def scenarios
      @@scenarios ||= (
        examples = run_feature(feature_build(feature), '/path/to/test.feature')

        s1 = TurnipFormatter::Resource::Scenario::Pass.new(examples[0])
        s2 = TurnipFormatter::Resource::Scenario::Pass.new(examples[1])
        s3 = TurnipFormatter::Resource::Scenario::Failure.new(examples[2])
        s4 = TurnipFormatter::Resource::Scenario::Pending.new(examples[3])
        s5 = TurnipFormatter::Resource::Scenario::Pass.new(examples[4])

        stub(s1).run_time { 10.0 }
        stub(s2).run_time {  3.0 }
        stub(s3).run_time {  1.0 }
        stub(s4).run_time {  5.0 }
        stub(s5).run_time {  4.0 }

        [s1, s2, s3, s4, s5]
      )
    end

    def feature
      <<-EOS
      Feature: A

        Scenario: A
          When A

        Scenario: B
          When B

        Scenario: C
          When [ERROR] C

        Scenario: D
          When [PENDING] D

        Scenario: E
          When E
      EOS
    end
  end
end
