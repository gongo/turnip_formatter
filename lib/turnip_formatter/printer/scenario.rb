require 'turnip_formatter/printer'
require 'turnip_formatter/printer/runtime_error'
require 'turnip_formatter/renderer/html/scenario'

module TurnipFormatter
  module Printer
    class Scenario
      class << self
        include TurnipFormatter::Printer

        def print_out(scenario)
          #
          # TODO output for scenario.valid? == false
          #
          TurnipFormatter::Renderer::Html::Scenario.new(scenario).render
        rescue => e
          TurnipFormatter::Printer::RuntimeError.print_out(scenario.example, e)
        end
      end
    end
  end
end
