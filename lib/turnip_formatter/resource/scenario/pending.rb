require 'turnip_formatter/resource/scenario/base'
require 'turnip_formatter/resource/step/pending'

module TurnipFormatter
  module Resource
    module Scenario
      class Pending < Base
        #
        # Return steps
        #
        # example:
        #
        #   When foo
        #    And bar
        #    And baz  <= pending line
        #   Then piyo
        #
        #   # => [
        #   #   <Step::Pass 'foo'>
        #   #   <Step::Pass 'bar'>
        #   #   <Step::Pending 'baz'>
        #   #   <Step::Unexecute 'piyo'>
        #   # ]
        #
        def steps
          raw_steps.map do |rs|
            if rs.line < pending_line_number
              klass = TurnipFormatter::Resource::Step::Pass
            elsif rs.line == pending_line_number
              klass = TurnipFormatter::Resource::Step::Pending
            else
              klass = TurnipFormatter::Resource::Step::Unexecute
            end

            klass.new(example, rs)
          end
        end

        private

        def pending_line_number
          example.metadata[:line_number]
        end
      end
    end
  end
end
