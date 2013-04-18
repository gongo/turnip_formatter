# -*- coding: utf-8 -*-

require 'erb'
require 'rspec/core/formatters/snippet_extractor'

module TurnipFormatter
  class Template
    include ERB::Util
    include RSpec::Core::BacktraceFormatter

    def print_header
      <<-EOS
        <!DOCTYPE html>
          <head>
            <meta charset="UTF-8">
            <style>
            #{File.read(File.dirname(__FILE__) + '/formatter.css')}
            </style>
            <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.min.js"></script>
            <script>
              $(function() {
                  ["passed", "failed", "pending"].forEach(function(status) {
                      $('#' + status + '_check').click(function() {
                          if (this.checked) {
                              $('.scenario.' + status).show();
                          } else {
                              $('.scenario.' + status).hide();
                          }
                      });
                  });
              });
            </script>
          </head>
          <body>
            #{report_area}
            <div id="main" role="main">
      EOS
    end

    def print_footer(total_count, failed_count, pending_count, total_time)
      update_report_js_tmp = '<script type="text/javascript">document.getElementById("%s").innerHTML = "%s";</script>'
      update_report_js = ''

      
      %w{ total_count failed_count pending_count total_time }.each do |key|
        update_report_js += update_report_js_tmp % [key, eval(key)]
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

    def print_runtime_error(example, exception)
      
      if example.exception
        example_backtrace = format_backtrace(example.exception.backtrace[0..14], example.metadata).map do |l|
          RSpec::Core::Metadata::relative_path(l)
        end
      end

      template_exception.result(binding)
    end

    private

    def feature_name(scenario)
      path = RSpec::Core::Metadata::relative_path(scenario.feature_file_path)
      name = scenario.feature_name
      "\"#{name}\" in #{path}"
    end

    def scenario_tags(scenario)
      return '' if scenario.tags.empty?
      template_scenario_tags.result(binding)
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
      '<pre class="multiline">' + h(lines) + '</pre>'
    end

    def step_source(location)
      @snippet_extractor ||= ::RSpec::Core::Formatters::SnippetExtractor.new
      '<pre class="source"><code class="ruby">' + @snippet_extractor.snippet([location]) + '</code></pre>'
    end

    def step_exception(exception)
      template_step_exception.result(binding)
    end

    def report_area
      <<-EOS
        <div id="report">
          <h1>Turnip Report</h1>
          <section class="checkbox">
            <label for="passed_check">Passed</label><input type="checkbox" checked id="passed_check">
            <label for="failed_check">Failed</label><input type="checkbox" checked id="failed_check">
            <label for="pending_check">Pending</label><input type="checkbox" checked id="pending_check">
          </section>
           
          <section class="result">
            <p>
              <span id="total_count"></span> Scenario (<span id="failed_count"></span> failed <span id="pending_count"></span> pending).
            </p>
            <p>Finished in <span id="total_time"></span></p>
          </section>
        </div>
      EOS
    end

    def template_scenario
      @template_scenario ||= ERB.new(<<-EOS)
        <section class="scenario <%= h(scenario.status) %>">
          <header>
            <span class="permalink">
              <a href="#<%= scenario.object_id %>">&para;</a>
            </span>
            <span class="scenario_name" id="<%= scenario.object_id %>">
              Scenario: <%= h(scenario.name) %>
            </span>
            <span class="feature_name">(Feature: <%= h(feature_name(scenario)) %>)</span>
          </header>
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

    def template_scenario_tags
      @template_scenario_tags ||= ERB.new(<<-EOS)
        <ul class="tags">
          <% scenario.tags.each do |tag| %>
          <li>@<%= h(tag) %></li>
          <% end %>
       </ul>
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
        <section class="exception">
          <h1>TurnipFormatter RuntimeError</h1>
          <dl>
            <dt>Exception</dt>
            <dd><%= h(exception.to_s) %></dd>

            <dt>Example Full Description</dt>
            <dd><%= h(example.metadata[:full_description]) %></dd>

            <% if example.exception %>
              <dt>Example Exception</dt>
              <dd><%= h(example.exception.to_s) %></dd>
   
              <dt>Backtrace:</dt>
              <dd>
                <ol>
                  <% example_backtrace.each do |line| %>
                  <li><%= h(line) %></li>
                  <% end %>
                </ol>
              </dd>
            <% end %>

            <% if example.pending %>
              <dt>Example Pending description</dt>
              <dd><%= h(example.metadata[:description]) %></dd>
            <% end %>
          </dl>
        </section>
      EOS
    end
  end
end
