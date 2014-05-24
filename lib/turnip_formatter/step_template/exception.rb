require 'turnip_formatter/step_template/base'
require 'erb'

module TurnipFormatter
  module StepTemplate
    class Exception < Base
      on_failed :build_failed
      on_pending :build_pending

      def self.scss
        <<-EOS
          div#steps-statistics section.scenario {
              ul.steps {
                  div.step_exception {
                      margin: 1em 0em;
                      padding: 1em 0em 1em 1em;
                      border: 1px solid #999999;
                      background-color: #eee8d5;
                      color: #586e75;

                      > pre {
                          margin-left: 1em;
                      }
                  }
              }
          }
        EOS
      end

      #
      # @param  [RSpec::Core::Example]  example
      #
      def build_failed(example)
        build(example.exception)
      end

      #
      # @param  [RSpec::Core::Example]  example
      #
      def build_pending(example)
        message = example.execution_result[:pending_message]
        exception = RSpec::Core::Pending::PendingDeclaredInExample.new(message)
        exception.set_backtrace([example.location])
        build(exception)
      end

      private

        def build(exception)
          template_step_exception.result(binding)
        end

        def template_step_exception
          @template_step_exception ||= ERB.new(<<-EOS)
            <div class="step_exception">
              <span>Failure:</span>
              <pre><%= ERB::Util.h(exception.to_s) %></pre>
              <span>Backtrace:</span>
              <ol>
                <% exception.backtrace.each do |line| %>
                <li><%= ERB::Util.h(line) %></li>
                <% end %>
              </ol>
            </div>
          EOS
        end
    end
  end
end
