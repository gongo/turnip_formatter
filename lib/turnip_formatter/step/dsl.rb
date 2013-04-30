require 'turnip_formatter/step'

module TurnipFormatter
  class Step
    module DSL
      #
      # @param [TurnipFormatter::Step]  step
      #
      def extended(step)
        ::TurnipFormatter::Step.templates[status].each do |style, block|
          step.docs[style] = step.instance_eval(&block)
        end
      end

      def add_template(style, &block)
        ::TurnipFormatter::Step.add_template(status, style, &block)
      end
    end
  end
end
