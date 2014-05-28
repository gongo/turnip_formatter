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
              div.steps {
                  div.step_exception {
                      margin: 1em 0em;
                      padding: 1em;
                      border: 1px solid #999999;
                      background-color: #eee8d5;
                      color: #586e75;

                      dd {
                          margin-top: 1em;
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
              <dl>
                <dt>Failure:</dt>
                <dd>
                  <pre><%= ERB::Util.h(exception.to_s) %></pre>
                </dd>
                <dt>Backtrace:</dt>
                <dd>
                  <ol>
                    <% exception.backtrace.each do |line| %>
                    <li><%= ERB::Util.h(line) %></li>
                    <% end %>
                  </ol>
                </dd>
              </dl>
            </div>
          EOS
        end
    end
  end
end
