require 'forwardable'

module TurnipFormatter
  module Resource
    module Step
      class Unexecute < Base
        def status
          :unexecute
        end
      end
    end
  end
end
