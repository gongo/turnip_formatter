require 'turnip_formatter/printer'
require 'turnip_formatter/renderer/html/step'

module TurnipFormatter
  module Printer
    class Step
      class << self
        include TurnipFormatter::Printer

        def print_out(step)
          TurnipFormatter::Renderer::Html::Step.new(step).render
        end
      end
    end
  end
end
