require 'turnip_formatter/step_template/base'

module TurnipFormatter
  module StepTemplate
    class Source < Base
      on_failed :build

      def self.css
        <<-EOS
          pre.source {
              font-size: 12px;
              font-family: monospace;
              background-color: #073642;
              color: #dddddd;
          }

          pre.source code.ruby {
              padding: 0.1em 0 0.2em 0;
          }

          pre.source code.ruby .linenum {
              width: 75px;
              color: #fffbd3;
              padding-right: 1em;
          }

          pre.source code.ruby .offending {
              background-color: gray;
          }
        EOS
      end

      def build(example)
        code = extractor.snippet([location(example)])
        '<pre class="source"><code class="ruby">' + code + '</code></pre>'
      end

      private

      def location(example)
        exception = example.exception

        if example.exception.is_a?(RSpec::Core::MultipleExceptionError)
          exception = example.exception.all_exceptions.first
        end

        formatted_backtrace(example, exception).first
      end

      def extractor
        @extractor ||= begin
                         # RSpec 3.4
                         require 'rspec/core/formatters/html_snippet_extractor'
                         ::RSpec::Core::Formatters::HtmlSnippetExtractor.new
                       rescue LoadError
                         # RSpec 3.3 or earlier
                         require 'rspec/core/formatters/snippet_extractor'
                         ::RSpec::Core::Formatters::SnippetExtractor.new
                       end
      end
    end
  end
end
