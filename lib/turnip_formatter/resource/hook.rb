module TurnipFormatter
  module Resource
    class Hook
      attr_reader :example
      attr_reader :keyword
      attr_reader :status

      #
      # @param  [RSpec::Core::Example]  example
      #
      def initialize(example, keyword, status)
        @example = example
        @keyword = keyword
        @status = status
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
  end
end
