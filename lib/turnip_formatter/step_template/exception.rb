require 'turnip_formatter/step_template/base'
require 'erb'
require 'ostruct'

module TurnipFormatter
  module StepTemplate
    class Exception < Base
      on_failed :build_failed
      on_pending :build_pending

      def self.css
        <<-EOS
          section.scenario div.steps div.step_exception {
              margin: 1em 0em;
              padding: 1em;
              border: 1px solid #999999;
              background-color: #eee8d5;
              color: #586e75;
          }

          section.scenario div.steps div.step_exception dd {
              margin-top: 1em;
              margin-left: 1em;
          }

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

      #
      # @param  [TurnipFormatter::Resource::Step::Failure]  step
      #
      def build_failed(step)
        datas = step.exceptions.map do |e|
          backtrace = formatted_backtrace(step.example, e)
          code = extractor.snippet([backtrace.first])

          {
            code: code,
            message: e.to_s,
            backtrace: backtrace,
          }
        end

        render(exceptions: datas)
      end

      #
      # @param  [TurnipFormatter::Resource::Step::Pending]  step
      #
      def build_pending(step)
        datas = [{
                   code: nil,
                   message: step.pending_message,
                   backtrace: [step.pending_location]
                 }]

        render(exceptions: datas)
      end

      private

      def render(args)
        view.result(OpenStruct.new(args).instance_eval { binding })
      end

      def view
        @view ||= ::ERB.new(File.read(File.dirname(__FILE__) + '/exception.html.erb'))
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

      def formatted_backtrace(example, exception = nil)
        RSpec::Core::Formatters::TurnipFormatter.formatted_backtrace(example, exception)
      end
    end
  end
end
