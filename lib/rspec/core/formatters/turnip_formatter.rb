# -*- coding: utf-8 -*-

require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/printer/index'
require 'turnip_formatter/printer/scenario'
require_relative './turnip_formatter/for_rspec2'
require_relative './turnip_formatter/for_rspec3'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_accessor :scenarios

        if Formatters.respond_to?(:register)
          include TurnipFormatter::ForRSpec3
          extend TurnipFormatter::ForRSpec3::Helper
        else
          include TurnipFormatter::ForRSpec2
          extend TurnipFormatter::ForRSpec2::Helper
        end

        def initialize(output)
          super(output)
          @scenarios = []
        end

        private

        def output_html(params)
          output.puts ::TurnipFormatter::Printer::Index.print_out(params)
        end
      end
    end
  end
end
