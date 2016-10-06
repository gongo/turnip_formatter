require 'active_support/core_ext/string/inflections' # String#{demodulize,underscore}
require 'tilt/erb'
require 'forwardable'

module TurnipFormatter
  module Renderer
    module Html
      class Base
        extend Forwardable

        TEMPLATE_DIRECTORY = File.dirname(__FILE__) + '/views'

        class << self
          def view
            @view ||= ::Tilt::ERBTemplate.new(
              "#{TEMPLATE_DIRECTORY}/#{resource_name}.html.erb"
            )
          end

          def resource_name
            @resource_name ||= self.to_s.demodulize.underscore
          end

          def delegate(*props)
            def_delegators :@resource, *props
          end
        end

        def initialize(resource)
          @resource = resource
        end

        def id
          @id ||= self.class.resource_name + '_' + @resource.object_id.to_s
        end

        def view
          self.class.view
        end

        def render
          view.render(self)
        end
      end
    end
  end
end
