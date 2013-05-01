# -*- coding: utf-8 -*-

require 'erb'
require 'rspec/core/formatters/snippet_extractor'

module TurnipFormatter
  class Template
    module StepSource
      def self.build(location)
        @snippet_extractor ||= ::RSpec::Core::Formatters::SnippetExtractor.new
        '<pre class="source"><code class="ruby">' + @snippet_extractor.snippet([location]) + '</code></pre>'
      end
    end
  end
end
