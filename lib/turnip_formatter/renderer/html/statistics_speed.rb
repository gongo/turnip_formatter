require 'turnip_formatter/renderer/html/base'
require 'ostruct'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [Array<TurnipFormatter::Resource::Scenario::XXX>]
      #
      class StatisticsSpeed < Base
        def results
          @results ||= analysis(scenarios)
        end

        private

        #
        # Use the successfully steps only
        #
        def scenarios
          @scenarios ||= @resource.select { |s| s.status == :passed }
        end

        def analysis(scenarios)
          scenarios.map do |s|
            OpenStruct.new(
              {
                id: s.id,
                feature_name: s.feature.name,
                name: s.name,
                run_time: s.run_time
              }
            )
          end.sort { |a, b| a.run_time <=> b.run_time }
        end
      end
    end
  end
end
