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
