# -*- coding: utf-8 -*-

require 'uri'

module TurnipFormatter
  class Template
    class << self
      def project_name
        TurnipFormatter.configuration.title
      end

      def add_javascript(script)
        case
        when local_file?(script)
          add_javascript_code File.read(script)
        when remote_url?(script)
          add_javascript_link script
        end
      end

      def add_stylesheet(stylesheet)
        case
        when local_file?(stylesheet)
          add_stylesheet_code File.read(stylesheet)
        when remote_url?(stylesheet)
          add_stylesheet_link stylesheet
        end
      end

      def render_javascript_codes
        js_code_list.join("\n")
      end

      def render_javascript_links
        js_file_list.map do |file|
          "<script src=\"#{file}\" type=\"text/javascript\"></script>"
        end.join("\n")
      end

      def render_stylesheet_codes
        TurnipFormatter.step_templates.each do |template|
          add_stylesheet_code(template.class.css)
        end

        css_code_list.join("\n")
      end

      def render_stylesheet_links
        css_file_list.map do |file|
          "<link rel=\"stylesheet\" href=\"#{file}\">"
        end.join("\n")
      end

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

      private

      def add_javascript_code(code)
        js_code_list << code
      end

      def add_javascript_link(link)
        js_file_list << link
      end

      def add_stylesheet_code(code)
        css_code_list << code
      end

      def add_stylesheet_link(file)
        css_file_list << file
      end

      def local_file?(path)
        File.exist? path
      end

      def remote_url?(path)
        uri = URI.parse(path)
        return true if %w(http https).include?(uri.scheme)
        return true if (uri.scheme.nil? && path.start_with?('//'))
        false
      rescue URI::InvalidURIError
        null
      end
    end

    (File.dirname(__FILE__) + '/template').tap do |dirname|
      add_stylesheet(dirname + '/turnip_formatter.css')
      add_javascript(dirname + '/turnip_formatter.js')
    end
  end
end
