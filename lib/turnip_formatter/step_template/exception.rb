require 'turnip_formatter/step_template/base'
require 'slim'

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
        EOS
      end

      #
      # @param  [RSpec::Core::Example]  example
      #
      def build_failed(example)
        build(example.exception.to_s, formatted_backtrace(example))
      end

      #
      # @param  [RSpec::Core::Example]  example
      #
      def build_pending(example)
        build(example.execution_result.pending_message, [example.location])
      end

      private

        def build(message, backtrace)
          template_step_exception.render(Object.new, { message: message, backtrace: backtrace })
        end

        def template_step_exception
          @template_step_exception ||= Slim::Template.new(File.dirname(__FILE__) + "/exception.slim")
        end
    end
  end
end
