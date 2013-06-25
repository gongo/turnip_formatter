# -*- coding: utf-8 -*-

require 'turnip_formatter/step/failure'
require 'turnip_formatter/step/pending'
require 'erb'

module TurnipFormatter
  module StepTemplate
    module Exception
      def self.build(exception)
        template_step_exception.result(binding)
      end

      private

      def self.template_step_exception
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

  Template.add_scss(<<-EOS)
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

  Step::Failure.add_template StepTemplate::Exception do
    example.exception
  end

  Step::Pending.add_template StepTemplate::Exception do
    message = example.execution_result[:pending_message]
    exception = RSpec::Core::Pending::PendingDeclaredInExample.new(message)
    exception.set_backtrace(example.location)
    exception
  end
end
