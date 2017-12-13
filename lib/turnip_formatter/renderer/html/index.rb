require 'turnip_formatter'
require 'turnip_formatter/renderer/html/scenario'
require 'turnip_formatter/renderer/html/runtime_error'
require 'turnip_formatter/renderer/html/statistics_feature'
require 'turnip_formatter/renderer/html/statistics_tag'
require 'turnip_formatter/renderer/html/statistics_speed'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Hash]
      #
      #     scenarios: [Array<TurnipFormatter:Resource::Scenario::Base>]
      #     failed_count: [Integer]
      #     pending_count: [Integer]
      #     total_time: [Float]
      #
      class Index < Base
        def style_links
          Html.render_stylesheet_links
        end

        def style_codes
          Html.render_stylesheet_codes + Html.render_step_template_stylesheet_codes
        end

        def script_links
          Html.render_javascript_links
        end

        def script_codes
          Html.render_javascript_codes
        end

        def title
          Html.project_name + ' report'
        end

        def scenarios_html
          scenarios.map do |s|
            begin
              Scenario.new(s).render
            rescue => e
              RuntimeError.new([e, s]).render
            end
          end.join
        end

        def statistics_feature_html
          StatisticsFeature.new(scenarios).render
        end

        def statistics_tag_html
          StatisticsTag.new(scenarios).render
        end

        def statistics_speed_html
          StatisticsSpeed.new(scenarios).render
        end

        def result_status_all
          str = "#{scenarios.size} "
          str
        end

        def result_status_passed
          str = result_status_all.to_i - result_status_failed.to_i - result_status_pending.to_i
          str.to_s
        end

        def result_status_failed
          str = "#{@resource[:failed_count]}"
          str
        end

        def result_status_pending
          str = "#{@resource[:pending_count]}"
          str
        end

        def total_time
          t_t = @resource[:total_time] / 60
          t_t.to_s
        end

        def date_create
          t = Time.now
          t.strftime("%F %H:%M")
        end

        def turnip_version
          Turnip::VERSION
        end

        private

        def scenarios
          @resource[:scenarios]
        end
      end
    end
  end
end
