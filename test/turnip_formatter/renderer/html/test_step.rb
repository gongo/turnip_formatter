require 'helper'
require 'turnip_formatter/renderer/html/step'
require 'turnip_formatter/resource/step'

module TurnipFormatter::Renderer::Html
  class TestStep < Test::Unit::TestCase
    include TurnipFormatter::TestHelper

    sub_test_case 'step without argument' do
      def setup
        resource = TurnipFormatter::Resource::Step.new(nil, sample_step)
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
        resource = TurnipFormatter::Resource::Step.new(nil, sample_step_with_docstring)
        @renderer = Step.new(resource)
      end

      def test_render
        document = html_parse(@renderer.render).at_xpath('/div')

        assert_equal('When step with DocString', document.at_css('div.step-title').text)
        assert_not_nil(document.at_css('div.step-body'))
      end
    end
  end
end
