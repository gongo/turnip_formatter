module TurnipFormatter
  module StepTemplate
    class Base
      class << self
        def inherited(child)
          TurnipFormatter.step_templates << child
        end

        def on_failed(template)
          hooks[:failed] << template
        end

        def on_pending(template)
          hooks[:pending] << template
        end

        def hooks
          @hooks ||= { failed: [], pending: [] }
        end

        #
        # Return SCSS string that be used in this class
        #
        def scss
          ''
        end
      end

      #
      # Return parameters to be used in template
      #
      # @example
      #  class FooTemplate < TurnipFormatter::StepTemplate::Base
      #    def template(value)  # value == example.exception.backtrace.count
      #      "value = #{v}"
      #    end
      #
      #    def value(example)
      #      example.exception.backtrace.count
      #    end
      #  end
      #
      # @param  [RSpec::Core::Example]  example
      #
      def value(example)
        nil
      end
    end
  end
end
