require 'turnip_formatter/resource/step/base'

module TurnipFormatter
  module Resource
    module Step
      class Pending < Base
        attr_reader :pending_exception

        def status
          :pending
        end

        #
        # @param  [Exception]  exception
        #
        def set_pending_exception(exception)
          @pending_exception = exception
        end
      end
    end
  end
end
