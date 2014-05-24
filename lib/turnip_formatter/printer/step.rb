require 'turnip_formatter/printer'
require 'turnip_formatter/printer/step_extra_args'

module TurnipFormatter
  module Printer
    class Step
      class << self
        include TurnipFormatter::Printer

        def print_out(step)
          render_template(:step, { step: step, step_docs: documents(step) })
        end

        private

        def documents(step)
          templates = TurnipFormatter.step_templates_for(step.status)
          templates.map do |template, method|
            template.send(method, step.example)
          end.join("\n")
        end
      end
    end
  end
end
