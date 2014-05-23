require 'turnip_formatter/step'

module TurnipFormatter
  module Scenario
    class Base
      include RSpec::Core::BacktraceFormatter

      attr_reader :errors

      #
      # @param  [RSpec::Core::Example]  example
      #
      def initialize(example)
        @example = example
        @errors  = []
        clean_backtrace
      end

      def valid?
        unless example.metadata.has_key?(:turnip_formatter)
          @errors << 'has no steps information'
        end

        errors.empty?
      end

      def steps
        @steps ||= descriptions.map do |desc|
          TurnipFormatter::Step.new(example, desc)
        end
      end

      def id
        "scenario_" + object_id.to_s
      end

      #
      # @return  [String] scenario name
      #
      def name
        example.example_group.description
      end

      #
      # @return  [String] scenario status ('passed', 'failed' or 'pending')
      #
      def status
        example.execution_result[:status]
      end

      #
      # @return  [String] scenario run time
      #
      def run_time
        example.execution_result[:run_time]
      end

      def feature_info
        path = RSpec::Core::Metadata::relative_path(feature_file_path)
        "\"#{feature_name}\" in #{path}"
      end

      def feature_name
        example.example_group.metadata[:example_group][:example_group][:description]
      end

      def tags
        example.metadata[:turnip_formatter][:tags]
      end

      def example
        @example
      end

      private

        def feature_file_path
          example.metadata[:file_path]
        end

        def descriptions
          example.metadata[:turnip_formatter][:steps]
        end

        def clean_backtrace
          return if example.exception.nil?
          formatted = format_backtrace(example.exception.backtrace, example.metadata)
          example.exception.set_backtrace(formatted)
        end
    end
  end
end
