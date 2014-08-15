require 'haml'

module TurnipFormatter
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
        templates[name] = Haml::Engine.new(File.read(path))
      end

      templates[name]
    end

    def templates
      @templates ||= {}
    end
  end
end
