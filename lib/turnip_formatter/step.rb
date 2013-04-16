# -*- coding: utf-8 -*-

module TurnipFormatter
  class Step
    attr_reader :name, :docs

    def initialize(description)
      step_name, keyword, docstring = description
      @name = keyword + step_name
      @docs = {}
      @docs[:extra_args] = docstring unless docstring.empty?
    end

    def attention?
      false
    end
  end
end
