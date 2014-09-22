# -*- coding: utf-8 -*-

require 'uri'

module TurnipFormatter
  class Template
    class << self
      def project_name
        TurnipFormatter.configuration.title
      end

      def reset!
        @js_code_list = []
        @js_file_list = []
        @css_code_list = []
        @css_file_list = []
      end

      def add_javascript(script)
        case
        when local_file?(script)
          js_code_list << File.read(script)
        when remote_url?(script)
          js_file_list << script
        end
      end

      def add_stylesheet(stylesheet)
        case
        when local_file?(stylesheet)
          css_code_list << File.read(stylesheet)
        when remote_url?(stylesheet)
          css_file_list << stylesheet
        end
      end

      def render_javascript_codes
        js_code_list.join("\n")
      end

      def render_javascript_links
        js_file_list.map do |file|
          "<script src=\"#{file}\"></script>"
        end.join("\n")
      end

      def render_stylesheet_codes
        codes = TurnipFormatter.step_templates.map do |template|
          template.class.css
        end

        codes.concat(css_code_list).join("\n")
      end

      def render_stylesheet_links
        css_file_list.map do |file|
          "<link rel=\"stylesheet\" href=\"#{file}\">"
        end.join("\n")
      end

      private

      def js_code_list
        @js_code_list ||= []
      end

      def js_file_list
        @js_file_list ||= []
      end

      def css_code_list
        @css_code_list ||= []
      end

      def css_file_list
        @css_file_list ||= []
      end

      def local_file?(path)
        File.exist? path
      end

      def remote_url?(path)
        uri = URI.parse(path)
        return true if %w(http https).include?(uri.scheme)
        return true if uri.scheme.nil? && path.start_with?('//')
        false
      rescue URI::InvalidURIError
        nil
      end
    end

    (File.dirname(__FILE__) + '/template').tap do |dirname|
      add_stylesheet(dirname + '/turnip_formatter.css')
      add_javascript(dirname + '/turnip_formatter.js')
    end
  end
end
