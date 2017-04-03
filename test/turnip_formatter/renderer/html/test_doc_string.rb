require 'helper'
require 'turnip_formatter/renderer/html/doc_string'

module TurnipFormatter::Renderer::Html
  class TestDocString < Test::Unit::TestCase
    def test_render
      renderer = DocString.new(<<-'EOS')
        I Am a Cat
      EOS

      document = html_parse(renderer.render).at_xpath('pre')

      assert_equal('step_doc_string', document.get('class'))
      assert_equal('I Am a Cat', document.text.strip)
    end
  end
end
