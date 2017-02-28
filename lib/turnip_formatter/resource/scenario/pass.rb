require 'turnip_formatter/resource/scenario/base'

module TurnipFormatter
  module Resource
    module Scenario
      class Pass < Base
        def steps
          raw_steps.map do |rs|
            TurnipFormatter::Resource::Step::Pass.new(example, rs)
          end
        end
      end
    end
  end
end
