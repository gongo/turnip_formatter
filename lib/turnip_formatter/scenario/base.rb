require 'turnip_formatter/step'

module TurnipFormatter
  module Scenario
    class Base
      attr_reader :errors

      #
      # @param  [RSpec::Core::Example]  example
      #
      def initialize(example)
        @example = example
        @errors  = []

        validation
      end

      def valid?
        errors.empty?
      end

      def steps
        @steps ||= raw_steps.map do |step|
          TurnipFormatter::Step.new(example, step)
        end
      end

      def id
        'scenario_' + object_id.to_s
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
        execution_result.status.to_s
      end

      #
      # @return  [String] scenario run time
      #
      def run_time
        execution_result.run_time
      end

      def feature_info
        path = RSpec::Core::Metadata.relative_path(feature_file_path)
        "\"#{feature_name}\" in #{path}"
      end

      def feature_name
        parent_example_group[:description]
      end

      def tags
        example.metadata[:turnip_formatter][:tags]
      end

      def example
        @example
      end

      protected

      def validation
        unless example.metadata.key?(:turnip_formatter)
          @errors << 'has no steps information'
        end
      end

      private

      def feature_file_path
        example.metadata[:file_path]
      end

      def raw_steps
        example.metadata[:turnip_formatter][:steps]
      end

      #
      # @return  [Hash]  parent example group
      #
      def parent_example_group
        if example.example_group.metadata.key?(:parent_example_group)
          # RSpec 3
          example.example_group.metadata[:parent_example_group]
        else
          # RSpec 2
          example.example_group.metadata[:example_group][:example_group]
        end
      end

      #
      # @return  [OpenStruct or ::RSpec::Core::Example::ExecutionResult]
      #
      def execution_result
        @execution_result ||= Helper.example_execution_result(example)
      end
    end
  end
end
