require 'turnip_formatter/html/printer'
require 'turnip_formatter/html/printer/step'
require 'turnip_formatter/html/printer/runtime_error'

module TurnipFormatter
  module Html
    module Printer
      class Scenario
        class << self
          include TurnipFormatter::Html::Printer

          def print_out(scenario)
            #
            # TODO output for scenario.valid? == false
            #
            render_template(:scenario, scenario: scenario) if scenario.valid?
          rescue => e
            TurnipFormatter::Html::Printer::RuntimeError.print_out(scenario.example, e)
          end
        end
      end
    end
  end
end
