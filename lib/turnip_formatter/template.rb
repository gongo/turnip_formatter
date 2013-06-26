# -*- coding: utf-8 -*-

require 'erb'
require 'rspec/core/formatters/helpers'
require 'turnip_formatter/template/tab/speed_statistics'
require 'turnip_formatter/template/tab/feature_statistics'
require 'turnip_formatter/template/tab/tag_statistics'
require 'sass'

module TurnipFormatter
  class Template
    include ERB::Util
    include RSpec::Core::BacktraceFormatter

    class << self
      def add_js(js_string)
        js_list << js_string
      end

      def js_render
        js_list.join("\n")
      end

      def css_render
        css_list.join("\n")
      end

      def add_scss(scss_string)
        css_list << scss_compile(scss_string)
      end

      def js_list
        @js_list ||= []
      end

      def css_list
        @css_list ||= []
      end

      def scss_compile(scss)
        Sass::Engine.new(scss, syntax: :scss).render
      end
    end

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
              #{self.class.css_render}
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

                   #{self.class.js_render}
              });
            </script>
          </head>
          <body>
            #{print_section_report}
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
      render_template(:scenario, { scenario: scenario })
    end

    def print_runtime_error(example, exception)
      exception.set_backtrace(format_backtrace(exception.backtrace))
      render_template(:exception, { example: example, exception: exception })
    end

    def print_exception_backtrace(e)
      render_template(:exception_backtrace, { backtrace: e.backtrace })
    end

    def print_scenario_tags(scenario)
      if scenario.tags.empty?
        ''
      else
        render_template(:scenario_tags, { tags: scenario.tags })
      end
    end

    def print_step_extra_args(extra_args)
      extra_args.map do |arg|
        if arg.instance_of?(Turnip::Table)
          print_step_outline(arg)
        else
          print_step_multiline(arg)
        end
      end.join("\n")
    end

    def print_step_outline(table)
      render_template(:step_outline, { table: table.to_a })
    end

    def print_step_multiline(lines)
      render_template(:step_multiline, { lines: lines })
    end

    def print_section_report
      render_template(:section_report)
    end

    private

    def step_attr(step)
      attr = 'step'
      attr += " #{step.status}" if step.attention?
      "class=\"#{h(attr)}\""
    end

    def step_args(step)
      output = []

      step.docs.each do |style, template|
        if style == :extra_args
          output << print_step_extra_args(template[:value])
        else
          output << template[:klass].build(template[:value])
        end
      end

      output.join("\n")
    end

    #
    # @example
    #   render_template(:main, { name: 'user' })
    #     # => ERB.new('/path/to/main.erb') render { name: 'user' }
    #
    def render_template(name, params = {})
      render_template_list(name).result(template_params_binding(params))
    end

    def render_template_list(name)
      if templates[name].nil?
        path = File.dirname(__FILE__) + "/template/#{name.to_s}.erb"
        templates[name] = ERB.new(File.read(path))
      end

      templates[name]
    end

    def template_params_binding(params)
      code = params.keys.map { |k| "#{k} = params[#{k.inspect}];" }.join
      eval(code + ";binding")
    end

    def templates
      @templates ||= {}
    end
  end
end
