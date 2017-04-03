require 'turnip_formatter/renderer/html/base'
require 'ostruct'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Array<TurnipFormatter::Resource::Scenario::XXX>]
      #
      class StatisticsFeature < Base
        def results
          @results ||= features.map do |name, scenarios|
            analysis(name, scenarios)
          end
        end

        private

        def features
          @features ||= @resource.group_by { |s| s.feature.name }
        end

        def analysis(name, scenarios)
          group = scenarios.group_by { |s| s.status }
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
