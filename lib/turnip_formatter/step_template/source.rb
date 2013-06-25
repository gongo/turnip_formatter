# -*- coding: utf-8 -*-

require 'turnip_formatter/step/failure'
require 'rspec/core/formatters/snippet_extractor'

module TurnipFormatter
  module StepTemplate
    module Source
      def self.build(location)
        code = extractor.snippet([location])
        '<pre class="source"><code class="ruby">' + code + '</code></pre>'
      end

      private

      def self.extractor
        @extractor ||= ::RSpec::Core::Formatters::SnippetExtractor.new
      end
    end
  end

  Step::Failure.add_template(StepTemplate::Source) do
    example.exception.backtrace.first
  end
end
