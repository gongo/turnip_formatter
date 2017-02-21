require 'turnip_formatter'
require 'turnip_formatter/renderer/html/base'
require 'turnip_formatter/renderer/html/doc_string'
require 'turnip_formatter/renderer/html/data_table'
require 'turnip/table'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [TurnipFormatter::Resource::Step]
      #
      class Step < Base
        delegate :text, :status

        def keyword
          @resource.keyword.strip
        end

        def argument
          @argument ||= case @resource.argument
                        when ::Turnip::Table
                          DataTable.new(@resource.argument).render
                        when String
                          DocString.new(@resource.argument).render
                        end
        end

        def extra_information
          extra_information_templates.map do |template, method|
            template.send(method, @resource)
          end.join("\n")
        end

        def has_appendix?
          !!argument or !extra_information_templates.empty?
        end

        private

        def extra_information_templates
          @extra_information_templates ||= TurnipFormatter.step_templates_for(status)
        end
      end
    end
  end
end
