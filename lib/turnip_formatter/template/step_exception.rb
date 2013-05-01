# -*- coding: utf-8 -*-

require 'erb'

module TurnipFormatter
  class Template
    module StepException
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
end
