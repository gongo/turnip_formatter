require 'turnip_formatter/renderer/html/base'
require 'turnip/table'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Turnip::Table]
      #
      class DataTable < Base
        def headers
          @resource.headers
        end

        def rows
          @resource.rows
        end
      end
    end
  end
end
