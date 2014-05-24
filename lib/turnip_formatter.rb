# -*- coding: utf-8 -*-

require "turnip_formatter/version"
require 'turnip'

module TurnipFormatter
  class << self
    def step_templates
      @step_templates ||= []
    end
  end

  require 'rspec/core/formatters/turnip_formatter'
  require 'turnip_formatter/template'
  require 'turnip_formatter/step_template'
  require 'turnip_formatter/ext/turnip/rspec'
  require 'turnip_formatter/ext/turnip/builder'
  require 'turnip_formatter/printer/index'
end

RSpecTurnipFormatter = RSpec::Core::Formatters::TurnipFormatter

RSpec.configure do |config|
  config.add_setting :project_name, :default => "Turnip"
end
