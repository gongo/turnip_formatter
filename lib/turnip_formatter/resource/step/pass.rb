require 'turnip_formatter/resource/step/base'

module TurnipFormatter
  module Resource
    module Step
      class Pass < Base
        def status
          :passed
        end
      end
    end
  end
end
