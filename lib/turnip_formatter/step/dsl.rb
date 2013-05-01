# -*- coding: utf-8 -*-

require 'turnip_formatter/step'

module TurnipFormatter
  class Step
    module DSL
      #
      # @param [TurnipFormatter::Step]  step
      #
      def extended(step)
        templates.each do |style, template|
          step.docs[style] = {
            klass: template[:klass],
            value: step.instance_eval(&template[:block])
          }
        end
      end

      def add_template(style, template = nil, &block)
        ::TurnipFormatter::Step.add_template(status, style, template, &block)
      end

      def remove_template(style)
        ::TurnipFormatter::Step.remove_template(status, style)
      end

      def templates
        ::TurnipFormatter::Step.templates[status]
      end
    end
  end
end
