require 'turnip_formatter/printer'
require 'turnip_formatter/renderer/html/doc_string'
require 'turnip_formatter/renderer/html/data_table'

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

          if argument.is_a?(Turnip::Table)
            TurnipFormatter::Renderer::Html::DataTable.new(argument).render
          else
            TurnipFormatter::Renderer::Html::DocString.new(argument).render
          end
        end
      end
    end
  end
end
