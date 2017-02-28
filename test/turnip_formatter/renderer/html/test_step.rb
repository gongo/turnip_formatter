require 'helper'
require 'turnip_formatter/renderer/html/step'

module TurnipFormatter::Renderer::Html
  class TestStep < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    sub_test_case 'step without argument' do
      def setup
        resource = TurnipFormatter::Resource::Step::Pass.new(nil, sample_step)
        @renderer = Step.new(resource)
      end

      def test_render
        document = html_parse(@renderer.render).at_xpath('/div')

        assert_equal('step passed', document.get('class'))
        assert_equal('When step', document.at_css('div.step-title').text)
        assert_nil(document.at_css('div.step-body'))
      end
    end

    sub_test_case 'step with argument' do
      def setup
        resource = TurnipFormatter::Resource::Step::Pass.new(nil, sample_step_with_docstring)
        @renderer = Step.new(resource)
      end

      def test_render
        document = html_parse(@renderer.render).at_xpath('/div')

        assert_equal('When step with DocString', document.at_css('div.step-title').text)
        assert_not_nil(document.at_css('div.step-body'))
      end
    end

    sub_test_case 'step should be escaped html style' do
      def setup
        resource = TurnipFormatter::Resource::Step::Pass.new(nil, sample_step_should_escaping)
        @renderer = Step.new(resource)
      end

      def test_render
        rendered = @renderer.render
        document = html_parse(@renderer.render).at_xpath('/div')

        assert_not_nil(%r{<div class="step-title">When step &gt;should&lt; escaped</div>}.match(rendered))
        assert_nil(document.at_css('div.step-body'))
      end
    end

    private

    def sample_step
      sample_feature.scenarios[0].steps[0]
    end

    def sample_step_with_docstring
      sample_feature.scenarios[0].steps[1]
    end

    def sample_step_should_escaping
      sample_feature.scenarios[0].steps[2]
    end

    def sample_feature
      feature_build(feature_text)
    end

    def feature_text
      <<-EOS
        Feature: Feature

          Scenario: Scenario
            When step
            When step with DocString
              """
              DocString
              """
            When step >should< escaped
      EOS
    end
  end
end
