require 'turnip_formatter/renderer/html/base'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Turnip::Table]
      #
      class DataTable < Base
        def table
          @resource
        end
      end
    end
  end
end
