require 'erb'
require 'rspec/core/formatters/snippet_extractor'

module TurnipFormatter
  class Template
    include ERB::Util

    def print_header
      <<-EOS
        <!DOCTYPE html>
          <head>
            <meta charset="UTF-8">
            <style>
            #{File.read(File.dirname(__FILE__) + '/formatter.css')}
            </style>
          </head>
          <body>
            <div id="report">
              <h1>Turnip Reports</h1>
              <span id="total_count"></span> Scenario (<span id="failed_count"></span> failed <span id="pending_count"></span> pending).
            </div>
            <div id="main" role="main">
      EOS
    end

    def print_footer(total_count, failed_count, pending_count)
      update_report_js_tmp = '<script type="text/javascript">document.getElementById("%s").innerHTML = "%s";</script>'
      update_report_js = ''

      { total_count: total_count, failed_count: failed_count, pending_count: pending_count }.each do |key, count|
        update_report_js += update_report_js_tmp % [key.to_s, count]
      end

      <<-EOS
            </div>
            #{update_report_js}
          </body>
        </html>
      EOS
    end

    def print_scenario(scenario)
      template_scenario.result(binding)
    end

    def print_runtime_error(exception)
      template_exception.result(binding)
    end

    private

    def feature_name(scenario)
      '<a href="file://' + scenario.feature_file_path + '">' + h(scenario.feature_name) + '</a>'
    end

    def scenario_tags(scenario)
      return '' if scenario.tags.empty?
      '<h3>Tags:' + scenario.tags.map {|tag| '@' + h(tag) }.join(" ") + '</h3>'
    end

    def step_attr(step)
      attr = 'step'
      attr += " #{step.status}" if step.attention?
      "class=\"#{h(attr)}\""
    end

    def step_args(step)
      args = []
      [:extra_args, :source, :exception].each do |k|
        args << send("step_#{k}", step.docs[k]) unless step.docs[k].nil?
      end
      args.join("\n")
    end

    def step_extra_args(extra_args)
      extra_args.map do |arg|
        if arg.instance_of?(Turnip::Table)
          step_outline(arg)
        else
          step_multiline(arg)
        end
      end.join("\n")
    end

    def step_outline(table)
      template_step_outline.result(binding)
    end

    def step_multiline(lines)
      '<pre>' + h(lines) + '</pre>'
    end

    def step_source(location)
      @snippet_extractor ||= ::RSpec::Core::Formatters::SnippetExtractor.new
      '<pre class="source"><code class="ruby">' + @snippet_extractor.snippet([location]) + '</code></pre>'
    end

    def step_exception(exception)
      template_step_exception.result(binding)
    end

    def template_scenario
      @template_scenario ||= ERB.new(<<-EOS)
        <section class="scenario <%= h(scenario.status) %>">
          <h1>Scenario: <%= h(scenario.name) %></h1>
          <h2>Feature: <%= feature_name(scenario) %></h2>
          <%= scenario_tags(scenario) %>
          <ul class="steps">
            <% scenario.steps.each do |step| %>
            <li <%= step_attr(step) %>><span><%= h(step.name) %></span>
              <div class="args"><%= step_args(step) %></div>
            </li>
            <% end %>
          </ul>
        </section>
      EOS
    end

    def template_step_outline
      @template_step_outline ||= ERB.new(<<-EOS)
        <table class="step_outline">
          <% table.each do |tr| %>
          <tr>
            <% tr.each do |td| %>
            <td><%= h(td) %></td>
            <% end %>
          </tr>
          <% end %>
        </table>
      EOS
    end

    def template_step_exception
      @template_step_exception ||= ERB.new(<<-EOS)
        <div class="step_exception">
          <span>Failure:</span>
          <pre><%= h(exception.to_s) %></pre>
          <span>Backtrace:</span>
          <ol>
            <% exception.backtrace.each do |line| %>
            <li><%= h(line) %></li>
            <% end %>
          </ol>
        </div>
      EOS
    end

    def template_exception
      @template_exception ||= ERB.new(<<-EOS)
        <div class="exception">
          <span>TurnipFormatter Error:</span>
          <pre><%= h(exception.to_s) %></pre>
          <span>Backtrace:</span>
          <ol>
            <% exception.backtrace.each do |line| %>
            <li><%= h(line) %></li>
            <% end %>
          </ol>
        </div>
      EOS
    end
  end
end
