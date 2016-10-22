require 'turnip_formatter/renderer/html/base'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Array<Exception, TurnipFormatter::Resource::Scenario::XXX>]
      #
      class RuntimeError < Base
        def runtime_exception
          @resource[0]
        end

        def scenario
          @resource[1]
        end
      end
    end
  end
end
