require 'forwardable'

module TurnipFormatter
  module Resource
    module Step
      class Base
        extend Forwardable
        def_delegators :@raw, :keyword, :text, :line, :argument

        attr_reader :example
        attr_accessor :status

        #
        # @param  [RSpec::Core::Example]  example
        # @param  [Turnip::Node::Step]    raw
        #
        def initialize(example, raw)
          @example = example
          @raw = raw
        end
      end
    end
  end
end
