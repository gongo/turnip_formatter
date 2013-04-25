require 'erb'

module TurnipFormatter
  class Template
    module StepOutline
      def self.build(table)
        template_step_outline.result(binding)
      end

    private

      def self.template_step_outline
        @template_step_outline ||= ERB.new(<<-EOS)
        <table class="step_outline">
        <% table.each do |tr| %>
          <tr>
            <% tr.each do |td| %>
            <td><%= ERB::Util.h(td) %></td>
            <% end %>
          </tr>
        <% end %>
        </table>
        EOS
      end
    end
  end
end
