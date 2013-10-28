# -*- coding: utf-8 -*-

require 'turnip_formatter/template'
require 'sass'

module TurnipFormatter
  class Template
    class << self
      def project_name
        RSpec.configuration.respond_to?(:project_name) ? RSpec.configuration.project_name : 'Turnip'
      end

      def add_js(js_string)
        js_list << js_string
      end

      def add_js_file(file)
        js_list << File.read(file)
      end

      def add_scss(scss_string)
        css_list << Sass::Engine.new(scss_string, scss_option).render
      end

      def add_scss_file(path)
        css_list << Sass::Engine.for_file(path, scss_option).render
      end

      def js_render
        js_list.join("\n")
      end

      def css_render
        css_list.join("\n")
      end

      def js_list
        @js_list ||= []
      end

      def css_list
        @css_list ||= []
      end

      def scss_option
        { syntax: :scss, style: :compressed }
      end
    end
  end
end

(File.dirname(__FILE__) + '/template').tap do |dirname|
  TurnipFormatter::Template.add_scss_file(dirname + '/turnip_formatter.scss')
  TurnipFormatter::Template.add_js_file(dirname + '/turnip_formatter.js')
end
