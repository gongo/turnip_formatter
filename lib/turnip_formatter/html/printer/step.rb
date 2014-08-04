require 'turnip_formatter/html/printer'
require 'turnip_formatter/html/printer/step_extra_args'

module TurnipFormatter
  module Html
    module Printer
      class Step
        class << self
          include TurnipFormatter::Html::Printer

          def print_out(step)
            step_templates = TurnipFormatter.step_templates_for(step.status)

            render_template(:step,
              {
                step: step,
                has_args_or_documents: has_args_or_documents?(step, step_templates),
                step_docs: documents(step, step_templates)
              }
              )
          end

          private

          def has_args_or_documents?(step, templates)
            (step.extra_args.length + templates.length) > 0
          end

          def documents(step, templates)
            templates.map do |template, method|
              template.send(method, step.example)
            end.join("\n")
          end
        end
      end
    end
  end
end
