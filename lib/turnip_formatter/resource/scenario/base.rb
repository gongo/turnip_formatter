require 'forwardable'
require 'turnip_formatter/resource/step/pass'
require 'turnip_formatter/resource/step/unexecute'

module TurnipFormatter
  module Resource
    module Scenario
      class Base
        attr_reader :example

        extend Forwardable
        def_delegators :raw, :line, :keyword, :name, :steps

        #
        # @param  [RSpec::Core::Example]  example
        #
        def initialize(example)
          @example = example
        end

        def id
          'scenario_' + object_id.to_s
        end

        #
        # @return  [Symbol] scenario status (:passed | :failed | :pending)
        #
        def status
          execution_result.status.to_sym
        end

        #
        # @return  [Float] scenario run time (sec)
        #
        def run_time
          execution_result.run_time
        end

        def feature_info
          path = RSpec::Core::Metadata.relative_path(feature_file_path)
          "\"#{feature.name}\" in #{path}"
        end

        def backgrounds
          feature.backgrounds
        end

        def tags
          @tags ||= (feature.tag_names + raw.tag_names).sort.uniq
        end

        def feature
          example.metadata[:turnip_formatter][:feature]
        end

        def raw_steps
          backgrounds.map(&:steps).flatten + raw.steps
        end

        private

        def raw
          @raw = example.metadata[:turnip_formatter][:scenario]
        end

        def feature_file_path
          example.metadata[:file_path]
        end

        #
        # @return  [OpenStruct or ::RSpec::Core::Example::ExecutionResult]
        #
        def execution_result
          @execution_result ||= example.execution_result
        end
      end
    end
  end
end
