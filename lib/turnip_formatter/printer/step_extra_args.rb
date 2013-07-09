require 'turnip_formatter/printer'

module TurnipFormatter
  module Printer
    class StepExtraArgs
      class << self
        include TurnipFormatter::Printer

        def print_out(args)
          args.map do |arg|
            if arg.instance_of?(Turnip::Table)
              render_template(:step_outline, { table: arg.to_a })
            else
              render_template(:step_multiline, { lines: arg })
            end
          end.join
        end
      end
    end
  end
end
