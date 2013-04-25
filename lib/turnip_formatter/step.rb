# -*- coding: utf-8 -*-

module TurnipFormatter
  class Step
    attr_reader :name, :docs, :example

    class << self
      def templates
        @templates ||= {}
      end

      def add_template(status, style, &block)
        templates[status] ||= {}
        templates[status][style] = block
      end

      def status
        ''
      end
    end

    #
    # @param  [RSpec::Core::Example]  example
    # @param  [Hash]  description
    #
    def initialize(example, description)
      @example = example
      @name = description[:keyword] + description[:name]
      @docs = { extra_args: description[:extra_args] }
    end

    def attention?
      !status.empty?
    end

    def status
      self.class.status
    end
  end
end
