require 'turnip_formatter/version'
require 'turnip'

module TurnipFormatter
  class << self
    def step_templates
      @step_templates ||= []
    end

    def step_templates_for(status)
      step_templates.reduce([]) do |templates, t|
        hooks = t.class.hooks
        next unless hooks.key?(status)
        templates + [t].product(hooks[status])
      end
    end
  end

  require 'rspec/core/formatters/turnip_formatter'
  require 'turnip_formatter/template'
  require 'turnip_formatter/step_template/exception'
  require 'turnip_formatter/step_template/source'
  require 'turnip_formatter/ext/turnip/rspec'
  require 'turnip_formatter/ext/turnip/builder'
  require 'turnip_formatter/printer/index'
end

RSpecTurnipFormatter = RSpec::Core::Formatters::TurnipFormatter

RSpec.configure do |config|
  config.add_setting :project_name, default: 'Turnip'
end
