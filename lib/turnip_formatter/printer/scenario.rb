require 'turnip_formatter/printer'
require 'turnip_formatter/printer/step'
require 'turnip_formatter/printer/runtime_error'

module TurnipFormatter
  module Printer
    class Scenario
      class << self
        include TurnipFormatter::Printer

        def print_out(scenario)
          #
          # TODO output for scenario.valid? == false
          #
          render_template(:scenario, scenario: scenario) if scenario.valid?
        rescue => e
          TurnipFormatter::Printer::RuntimeError.print_out(scenario.example, e)
        end
      end
    end
  end
end
