require 'turnip_formatter/version'
require 'turnip'
require 'turnip_formatter/renderer/html'

module TurnipFormatter
  class << self
    attr_accessor :title

    def step_templates
      @step_templates ||= []
    end

    def step_templates_for(status)
      step_templates.reduce([]) do |templates, t|
        hooks = t.class.hooks
        return templates unless hooks.key?(status)
        templates + [t].product(hooks[status])
      end
    end

    def add_stylesheet(stylesheets)
      stylesheets = [stylesheets] if stylesheets.is_a? String

      stylesheets.each do |s|
        TurnipFormatter::Renderer::Html.add_stylesheet(s)
      end
    end

    def add_javascript(scripts)
      scripts = [scripts] if scripts.is_a? String

      scripts.each do |s|
        TurnipFormatter::Renderer::Html.add_javascript(s)
      end
    end

    def configure
      yield self
    end

    def configuration
      self
    end
  end

  require 'rspec/core/formatters/turnip_formatter'
  require 'turnip_formatter/step_template/exception'
  require 'turnip_formatter/step_template/source'
  require 'turnip_formatter/ext/turnip/rspec'
end

RSpecTurnipFormatter = RSpec::Core::Formatters::TurnipFormatter

TurnipFormatter.configure do |config|
  config.title = 'Turnip'
end

(File.dirname(__FILE__) + '/turnip_formatter/renderer/html/assets').tap do |dirname|
  TurnipFormatter::Renderer::Html.add_stylesheet(dirname + '/turnip_formatter.css')
  TurnipFormatter::Renderer::Html.add_javascript(dirname + '/turnip_formatter.js')
end
