require 'turnip_formatter/printer'
require 'turnip_formatter/printer/step_extra_args'

module TurnipFormatter
  module Printer
    class Step
      class << self
        include TurnipFormatter::Printer

        def print_out(step)
          render_template(:step, { step: step, step_docs: documents(step.docs) })
        end

        private

        def documents(docs)
          docs.map do |style, template|
            if style == :extra_args
              TurnipFormatter::Printer::StepExtraArgs.print_out(template[:value])
            else
              #
              # Template class which is registered in
              #    +Step::Failure.add_template+
              #    +Step::Pending.add_template+
              # be called.
              #
              template[:klass].build(template[:value])
            end
          end.join("\n")
        end
      end
    end
  end
end
