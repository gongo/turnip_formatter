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

  Template.add_scss(<<-EOS)
    pre.source {
        font-size: 12px;
        font-family: monospace;
        background-color: #073642;
        color: #dddddd;

        code.ruby {
            padding: 0.1em 0 0.2em 0;

            .linenum {
                width: 75px;
                color: #fffbd3;
                padding-right: 1em;
            }

            .offending { background-color: gray; }
        }
    }
  EOS

  Step::Failure.add_template(StepTemplate::Source) do
    example.exception.backtrace.first
  end
end
