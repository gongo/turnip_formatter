require 'turnip_formatter/renderer/html/step'

module TurnipFormatter
  module Renderer
    module Html
      #
      # @resource [TurnipFormatter::Resource::Scenario::Base]
      #
      class Scenario < Base
        delegate :id, :status, :run_time, :tags, :feature_info, :name, :feature

        def steps_html
          @steps_html ||= @resource.steps.map do |step|
            Step.new(step).render
          end.join
        end
      end
    end
  end
end
