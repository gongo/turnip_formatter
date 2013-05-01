# -*- coding: utf-8 -*-

require 'erb'

module TurnipFormatter
  class Template
    module StepMultiline
      def self.build(lines)
        '<pre class="multiline">' + ERB::Util.h(lines) + '</pre>'
      end
    end
  end
end
