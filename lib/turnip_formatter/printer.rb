module TurnipFormatter
  module Printer
    include ERB::Util

    #
    # @example
    #   render_template(:main, { name: 'user' })
    #     # => ERB.new('/path/to/main.erb') render { name: 'user' }
    #
    def render_template(name, params = {})
      render_template_list(name).result(template_params_binding(params))
    end

    private

    def render_template_list(name)
      if templates[name].nil?
        path = File.dirname(__FILE__) + "/template/#{name.to_s}.erb"
        templates[name] = ERB.new(File.read(path))
      end

      templates[name]
    end

    def template_params_binding(params)
      code = params.keys.map { |k| "#{k} = params[#{k.inspect}];" }.join
      eval(code + ";binding")
    end

    def templates
      @templates ||= {}
    end
  end
end
