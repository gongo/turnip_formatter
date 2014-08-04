require 'turnip_formatter/html/printer'
require 'turnip_formatter/html/printer/step_extra_args'

module TurnipFormatter
  module Html
    module Printer
      class RuntimeError
        class << self
          include TurnipFormatter::Html::Printer

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
            unless example.exception
              ''
            else
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
  end
end
