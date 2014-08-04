require 'tilt'

module TurnipFormatter
  module Html
    module Printer
      #
      # @example
      #   render_template(:main, { name: 'user' })
      #     # => Tilt.new('/path/to/main.erb') render { name: 'user' }
      #
      def render_template(name, params = {})
        render_template_list(name).render(self, params)
      end

      private

      def render_template_list(name)
        if templates[name].nil?
          path = File.dirname(__FILE__) + "/template/#{name}.haml"
          templates[name] = Tilt.new(path)
        end

        templates[name]
      end

      def templates
        @templates ||= {}
      end
    end
  end
end
