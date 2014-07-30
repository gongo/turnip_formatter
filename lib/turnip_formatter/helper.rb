module TurnipFormatter
  module Helper
    module HelperMethods
      #
      # @param  [RSpec::Core::Example]  example
      # @param  [OpenStruct or ::RSpec::Core::Example::ExecutionResult]
      #
      def example_execution_result(example)
        case example.execution_result
        when Hash
          # RSpec 2
          OpenStruct.new(example.execution_result)
        when ::RSpec::Core::Example::ExecutionResult
          # RSpec 3
          example.execution_result
        end
      end
    end

    extend HelperMethods
  end
end
