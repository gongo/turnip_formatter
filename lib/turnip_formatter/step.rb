require 'forwardable'

module TurnipFormatter
  class Step
    extend Forwardable

    attr_reader :name, :example, :argument
    attr_accessor :status

    def_delegators :@raw, :argument, :line, :keyword, :description

    #
    # @param  [RSpec::Core::Example]   example
    # @param  [Turnip::Node::Step]  raw
    #
    def initialize(example, raw)
      @example = example
      @raw     = raw
      @name    = raw.keyword.strip + ' ' + raw.description
      @status  = :passed
    end
  end
end
