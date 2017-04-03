require 'turnip_formatter/renderer/html/base'
require 'ostruct'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Array<TurnipFormatter::Resource::Scenario::XXX>]
      #
      class StatisticsTag < Base
        def results
          @results ||= tags.map do |name, scenarios|
            analysis(name, scenarios)
          end
        end

        private

        def tags
          @tags ||= @resource.map do |scenario|
            if scenario.tags.empty?
              { name: 'no_tag', scenario: scenario }
            else
              scenario.tags.map do |tag|
                { name: '@' + tag, scenario: scenario }
              end
            end
          end.flatten.group_by { |s| s[:name] }.sort
        end

        def analysis(name, scenarios)
          group = scenarios.group_by { |s| s[:scenario].status }
          group.default = []

          info = OpenStruct.new(
            name: name,
            scenario_count: scenarios.size,
            passed_count: group[:passed].size,
            failed_count: group[:failed].size,
            pending_count: group[:pending].size,
            status: :failed
          )

          if info.failed_count.zero?
            info.status = info.pending_count.zero? ? :passed : :pending
          end

          info
        end
      end
    end
  end
end
