require 'turnip_formatter/resource/step/failure_result'
require 'turnip_formatter/resource/step/pending_result'

module TurnipFormatter
  module Resource
    module Step
      class Hook
        include ::TurnipFormatter::Resource::Step::FailureResult
        include ::TurnipFormatter::Resource::Step::PendingResult

        attr_reader :example

        #
        # @param  [RSpec::Core::Example]  example
        #
        def initialize(example)
          @example = example
          @exceptions = []
        end

        def status
          case
          when failed?
            :failed
          when pending?
            :pending
          else
            :passed
          end
        end

        def text
          ''
        end

        def line
          -1
        end

        def argument
          nil
        end
      end

      class BeforeHook < Hook
        def keyword
          'BeforeHook'
        end
      end

      class AfterHook < Hook
        def keyword
          'AfterHook'
        end
      end
    end
  end
end
