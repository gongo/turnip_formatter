require 'helper'
require 'tempfile'
require 'turnip_formatter/renderer/html'

module TurnipFormatter::Renderer
  class TestHtml < Test::Unit::TestCase
    def setup
      Html.reset!

      Html.add_javascript(@script_path)
      Html.add_stylesheet(@style_path)
    end

    def teardown
      Html.reset!
    end

    sub_test_case 'with local file' do
      def setup
        @script_path = Tempfile.open(['local', 'js']) do |f|
          f.write('var s = 1 + 1')
          f.path
        end

        @style_path = Tempfile.open(['local', 'css']) do |f|
          f.write('body { }')
          f.path
        end

        super
      end

      def test_render_javascript_codes
        assert_match(/#{Regexp.escape('var s = 1 + 1')}/, Html.render_javascript_codes)
      end

      def test_render_javascript_links
        assert Html.render_javascript_links.empty?
      end

      def test_render_stylesheet_codes
        assert_match(/#{Regexp.escape('body { }')}/, Html.render_stylesheet_codes)
      end

      def test_render_stylesheet_links
        assert Html.render_stylesheet_links.empty?
      end
    end

    sub_test_case 'with remote file' do
      def setup
        @script_path = 'http://example.com/foo.js'
        @style_path = 'http://example.com/foo.css'

        super
      end

      def test_render_javascript_codes
        assert Html.render_javascript_codes.empty?
      end

      def test_render_javascript_links
        assert_match(/#{Regexp.escape('http://example.com/foo.js')}/, Html.render_javascript_links)
      end

      def test_render_stylesheet_codes
        assert Html.render_stylesheet_codes.empty?
      end

      def test_render_stylesheet_links
        assert_match(/#{Regexp.escape('http://example.com/foo.css')}/, Html.render_stylesheet_links)
      end
    end
  end
end
