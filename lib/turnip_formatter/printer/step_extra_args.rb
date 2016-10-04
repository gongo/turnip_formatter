require 'turnip_formatter/printer'

module TurnipFormatter
  module Printer
    class StepExtraArgs
      class << self
        include TurnipFormatter::Printer

        #
        # @param  [nil or String or Turnip::Table]  Step argument
        #
        def print_out(argument)
          return '' if argument.nil?

          if argument.instance_of?(Turnip::Table)
            render_template(:step_outline, { table: argument.to_a })
          else
            render_template(:step_multiline, { lines: argument })
          end
        end
      end
    end
  end
end
