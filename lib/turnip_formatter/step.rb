module TurnipFormatter
  class Step
    attr_reader :name, :example, :extra_args
    attr_accessor :status

    #
    # @param  [RSpec::Core::Example]  example
    # @param  [Hash]  raw
    #
    def initialize(example, raw)
      @example    = example
      @name       = raw[:keyword].strip + ' ' + raw[:name]
      @extra_args = raw[:extra_args]
      @status     = :passed
    end
  end
end
