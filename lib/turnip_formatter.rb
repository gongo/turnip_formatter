require 'turnip_formatter/version'
require 'turnip'

module TurnipFormatter
  class << self
    def step_templates
      @step_templates ||= []
    end

    def step_templates_for(status)
      @step_templates_for ||= {}
      @step_templates_for.clear if stale_cache?

      @step_templates_for[status] ||= step_templates.reduce([]) do |templates, t|
        hooks = t.class.hooks
        next unless hooks.key?(status)
        templates + [t].product(hooks[status])
      end
    end

    private

      def stale_cache?
        @prev_template_count ||= 0
        current_template_count = step_templates.size

        result = (@prev_template_count != current_template_count)
        @prev_template_count = current_template_count
        result
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
