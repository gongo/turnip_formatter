require 'turnip_formatter/resource/step/base'

module TurnipFormatter
  module Resource
    module Step
      class Failure < Base
        attr_reader :exceptions

        def initialize(example, raw)
          super
          @exceptions = []
        end

        def status
          :failed
        end

        #
        # @param  [Array<Exception>]  exceptions
        #
        def set_exceptions(exceptions)
          @exceptions = exceptions
        end
      end
    end
  end
end
