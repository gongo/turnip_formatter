# -*- coding: utf-8 -*-

module TurnipFormatter
  class Step
    attr_reader :name, :docs, :example

    class << self
      def templates
        @templates ||= {}
      end

      def add_template(status, style, klass = nil, &block)
        templates[status] ||= {}
        templates[status][style] = { klass: klass, block: block }
      end

      def remove_template(status, style)
        templates[status].delete(style)
        templates.delete(status.to_sym) if templates[status.to_sym].empty?
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
      @docs = { extra_args: { klass: nil, value: description[:extra_args] } }
    end

    def attention?
      !status.empty?
    end

    def status
      self.class.status
    end
  end
end
