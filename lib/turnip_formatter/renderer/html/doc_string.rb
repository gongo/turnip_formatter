require 'turnip_formatter/renderer/html/base'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [String]
      #
      class DocString < Base
        def content
          @resource
        end
      end
    end
  end
end
