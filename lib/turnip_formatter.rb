# -*- coding: utf-8 -*-

require "turnip_formatter/version"
require 'turnip'

module TurnipFormatter
  require 'rspec/core/formatters/turnip_formatter'
  require 'turnip_formatter/template'
  require 'turnip_formatter/ext/turnip/rspec'
  require 'turnip_formatter/ext/turnip/builder'
end

RSpecTurnipFormatter = RSpec::Core::Formatters::TurnipFormatter

