module TurnipFormatter
  module Renderer
    module Html
      @script_codes = []
      @script_files = []
      @style_codes = []
      @style_files = []

      class << self
        attr_accessor :script_codes, :script_files, :style_codes, :style_files

        def reset!
          @script_codes = []
          @script_files = []
          @style_codes = []
          @style_files = []
        end

        def project_name
          TurnipFormatter.configuration.title
        end

        def add_javascript(script)
          case
          when local_file?(script)
            script_codes << File.read(script)
          when remote_url?(script)
            script_files << script
          end
        end

        def add_stylesheet(stylesheet)
          case
          when local_file?(stylesheet)
            style_codes << File.read(stylesheet)
          when remote_url?(stylesheet)
            style_files << stylesheet
          end
        end

        def render_javascript_codes
          script_codes.join("\n")
        end

        def render_javascript_links
          script_files.map do |file|
            "<script src=\"#{file}\"></script>"
          end.join("\n")
        end

        def render_stylesheet_codes
          codes = TurnipFormatter.step_templates.map do |template|
            template.class.css
          end

          codes.concat(style_codes).join("\n")
        end

        def render_stylesheet_links
          style_files.map do |file|
            "<link rel=\"stylesheet\" href=\"#{file}\">"
          end.join("\n")
        end

        private

        def local_file?(path)
          File.exist? path
        end

        def remote_url?(path)
          uri = URI.parse(path)
          return true if %w(http https).include?(uri.scheme)
          return true if uri.scheme.nil? && path.start_with?('//')
          false
        rescue URI::InvalidURIError
          false
        end
      end
    end
  end
end
