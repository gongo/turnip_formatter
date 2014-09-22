require 'turnip_formatter/printer'
require 'turnip_formatter/printer/step_extra_args'

module TurnipFormatter
  module Printer
    class RuntimeError
      class << self
        include TurnipFormatter::Printer

        def print_out(example, exception)
          render_template(:runtime_exception, {
              example: example,
              runtime_exception: runtime_exception(exception),
              example_exception: example_exception(example),
            }
          )
        end

        private

        def runtime_exception(exception)
          render_template(:exception, { title: 'Runtime', exception: exception })
        end

        def example_exception(example)
          return '' unless example.exception

          render_template(:exception, {
              title: 'Example',
              exception: example.exception
            }
          )
        end
      end
    end
  end
end
