require 'turnip_formatter/resource/scenario/base'

module TurnipFormatter
  module Resource
    module Scenario
      class Pass < Base
        def mark_status
          @steps.each do |step|
            step.mark_as_executed
          end
        end
      end
    end
  end
end
