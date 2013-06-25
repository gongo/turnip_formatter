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

      def add_template(klass, &block)
        ::TurnipFormatter::Step.add_template(status, klass, &block)
      end

      def remove_template(klass)
        ::TurnipFormatter::Step.remove_template(status, klass)
      end

      def templates
        ::TurnipFormatter::Step.templates[status] || []
      end
    end
  end
end
