module TurnipFormatter
  module Resource
    module Step
      class HookBase
        attr_reader :example
        attr_reader :exceptions

        #
        # @param  [RSpec::Core::Example]  example
        #
        def initialize(example)
          @example = example
          @exceptions = []
        end

        def set_exceptions(exceptions)
          @exceptions = exceptions
        end

        def status
          :failed
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

      class BeforeHook < HookBase
        def keyword
          'BeforeHook'
        end
      end

      class AfterHook < HookBase
        def keyword
          'AfterHook'
        end
      end
    end
  end
end
