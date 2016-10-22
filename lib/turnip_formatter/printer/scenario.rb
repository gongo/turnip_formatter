require 'turnip_formatter/printer'
require 'turnip_formatter/renderer/html/scenario'
require 'turnip_formatter/renderer/html/runtime_error'

module TurnipFormatter
  module Printer
    class Scenario
      class << self
        include TurnipFormatter::Printer

        def print_out(scenario)
          TurnipFormatter::Renderer::Html::Scenario.new(scenario).render
        rescue => e
          TurnipFormatter::Renderer::Html::RuntimeError.new([e, scenario]).render
        end
      end
    end
  end
end
