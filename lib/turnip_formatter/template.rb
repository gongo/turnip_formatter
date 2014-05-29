# -*- coding: utf-8 -*-

require 'turnip_formatter/template'
require 'sass'
require 'bootstrap-sass'

module TurnipFormatter
  class Template
    class << self
      def project_name
        RSpec.configuration.respond_to?(:project_name) ? RSpec.configuration.project_name : 'Turnip'
      end

      def add_javascript_code(code)
        js_code_list << code
      end

      def add_javascript_link(link)
        js_file_list << link
      end

      def add_stylesheet_code(code)
        css_code_list << Sass::Engine.new(code, scss_option).render
      end

      def add_stylesheet_link(file)
        css_file_list << file
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
          add_stylesheet_code(template.class.scss)
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

      def scss_option
        { syntax: :scss, style: :compressed }
      end
    end

    (File.dirname(__FILE__) + '/template').tap do |dirname|
      add_stylesheet_code(File.read(dirname + '/turnip_formatter.scss'))
      add_javascript_code(File.read(dirname + '/turnip_formatter.js'))
    end
  end
end
