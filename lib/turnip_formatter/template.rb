# -*- coding: utf-8 -*-

require 'erb'
require 'rspec/core/formatters/helpers'
require 'turnip_formatter/template/tab/speed_statistics'
require 'turnip_formatter/template/tab/feature_statistics'
require 'turnip_formatter/template/tab/tag_statistics'

module TurnipFormatter
  class Template
    include ERB::Util
    include RSpec::Core::BacktraceFormatter

    def print_header
      <<-EOS
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="UTF-8">
            <title>turnip formatter report</title>
            <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
            <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>
            <script src="http://cdnjs.cloudflare.com/ajax/libs/jquery.tablesorter/2.9.1/jquery.tablesorter.min.js"></script>

            <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.2/themes/smoothness/jquery-ui.css">
            <style>
            #{File.read(File.dirname(__FILE__) + '/formatter.css')}
            </style>

            <script>
              $(function() {
                  var scenarioHeader = 'section.scenario header';
                  $(scenarioHeader).siblings().hide();

                  /**
                   * Step folding/expanding
                   */
                  $(scenarioHeader).click(function() {
                      var steps = $(this).siblings();
                      steps.slideToggle();
                  });

                  /**
                   * All step folding/expanding action
                   */
                  $('#scenario_display_check').change(function() {
                      var steps = $(scenarioHeader).siblings();

                      if (this.checked) {
                          steps.slideUp();
                      } else {
                          steps.slideDown();
                      }
                  });

                  ["passed", "failed", "pending"].forEach(function(status) {
                      $('#' + status + '_check').click(function() {
                          if (this.checked) {
                              $('.scenario.' + status).show();
                          } else {
                              $('.scenario.' + status).hide();
                          }
                      });
                  });

                  /**
                   * Tabs
                   */
                   var tab_area = 'div#main';
                   $(tab_area).tabs();

                   $('div#speed-statistics a').click(function() {
                       $(tab_area).tabs("option", "active", 0);
                   });

                   $("div#speed-statistics table").tablesorter({
                       headers: {
                           1: { sorter: false }
                       }
                   });
              });
            </script>
          </head>
          <body>
            #{report_area}
            <div id="main" role="main">
              <ul>
                <li><a href="#steps-statistics">Steps</a></li>
                <li><a href="#speed-statistics">Speed Statistics</a></li>
                <li><a href="#feature-statistics">Feature Statistics</a></li>
                <li><a href="#tag-statistics">Tag Statistics</a></li>
              </ul>
      EOS
    end

    def print_main_header
      <<-EOS
        <div id="steps-statistics">
          <label><input type="checkbox" id="scenario_display_check" checked>step folding</label>
      EOS
    end

    def print_main_footer(total_count, failed_count, pending_count, total_time)
      update_report_js_tmp = '<script type="text/javascript">document.getElementById("%s").innerHTML = "%s";</script>'
      update_report_js = ''

      %w{ total_count failed_count pending_count total_time }.each do |key|
        update_report_js += update_report_js_tmp % [key, eval(key)]
      end

      "#{update_report_js}</div>"
    end

    def print_tab_speed_statsitics(passed_scenarios)
      statistics = TurnipFormatter::Template::Tab::SpeedStatistics.new(passed_scenarios)
      <<-EOS
        <div id="speed-statistics">
          <em>Ranking of running time of each <strong>successfully</strong> scenario:</em>
          #{statistics.build}
        </div>
      EOS
    end

    def print_tab_feature_statsitics(scenarios)
      statistics = TurnipFormatter::Template::Tab::FeatureStatistics.new(scenarios)
      <<-EOS
        <div id="feature-statistics">
          <em>The results for the feature:</em>
          #{statistics.build}
        </div>
      EOS
    end

    def print_tab_tag_statsitics(scenarios)
      statistics = TurnipFormatter::Template::Tab::TagStatistics.new(scenarios)
      <<-EOS
        <div id="tag-statistics">
          <em>The results for the tab:</em>
          #{statistics.build}
        </div>
      EOS
    end

    def print_footer
      <<-EOS
            </div>
            <footer>
              <p>Generated by <a href="https://rubygems.org/gems/turnip_formatter">turnip_formatter</a> #{TurnipFormatter::VERSION}</p>
              <p>Powered by <a href="http://jquery.com/">jQuery</a> 1.9.1, <a href="http://jqueryui.com/">jQuery UI</a> 1.10.2 and <a href="http://mottie.github.io/tablesorter/">tablesorter</a> 2.9.1</p>
            </footer>
          </body>
        </html>
      EOS
    end

    def print_scenario(scenario)
      template_scenario.result(binding)
    end

    def print_runtime_error(example, exception)
      exception.set_backtrace(format_backtrace(exception.backtrace))
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
      output = []

      step.docs.each do |style, template|
        if style == :extra_args
          output << step_extra_args(template[:value])
        else
          output << template[:klass].build(template[:value])
        end
      end

      output.join("\n")
    end

    def step_extra_args(extra_args)
      extra_args.map do |arg|
        arg.instance_of?(Turnip::Table) ? step_outline(arg) : step_multiline(arg)
      end.join("\n")
    end

    def step_outline(table)
      template_step_outline.result(binding)
    end

    def step_multiline(lines)
      '<pre class="multiline">' + h(lines) + '</pre>'
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
              <a href="#<%= scenario.id %>">&para;</a>
            </span>
            <span class="scenario_name" id="<%= scenario.id %>">
              Scenario: <%= h(scenario.name) %>
            </span>
            <span class="feature_name">
              (Feature: <%= h(feature_name(scenario)) %>)
              at <%= h(scenario.run_time) %> sec
            </span>
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

    def template_exception
      @template_exception ||= ERB.new(<<-EOS)
        <section class="exception">
          <h1>TurnipFormatter RuntimeError</h1>
          <dl>
            <dt>Runtime Exception</dt>
            <dd><%= h(exception.to_s) %></dd>

            <dt>Runtime Exception Backtrace</dt>
            <%= template_exception_backtrace(exception) %>

            <dt>Example Full Description</dt>
            <dd><%= h(example.metadata[:full_description]) %></dd>

            <% if example.exception %>
              <dt>Example Exception</dt>
              <dd><%= h(example.exception.to_s) %></dd>

              <dt>Example Backtrace</dt>
              <%= template_exception_backtrace(example.exception) %>
            <% end %>

            <% if example.pending %>
              <dt>Example Pending description</dt>
              <dd><%= h(example.metadata[:description]) %></dd>
            <% end %>
          </dl>
        </section>
      EOS
    end

    def template_exception_backtrace(exception)
      @template_exception_backtrace ||= ERB.new(<<-EOS)
        <dd>
          <ol>
            <% exception.backtrace.each do |line| %>
            <li><%= h(line) %></li>
            <% end %>
          </ol>
        </dd>
      EOS
      @template_exception_backtrace.result(binding)
    end

    def template_step_outline
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
