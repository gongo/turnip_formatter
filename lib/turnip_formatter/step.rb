require 'forwardable'

module TurnipFormatter
  class Step
    extend Forwardable

    attr_reader :name, :example, :extra_args
    attr_accessor :status

    def_delegators :@raw, :extra_args, :line, :keyword, :description

    #
    # @param  [RSpec::Core::Example]   example
    # @param  [Turnip::Builder::Step]  raw
    #
    def initialize(example, raw)
      @example = example
      @raw     = raw
      @name    = raw.keyword.strip + ' ' + raw.description
      @status  = :passed
    end
  end
end
