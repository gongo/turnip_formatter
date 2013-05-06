# -*- coding: utf-8 -*-

require 'turnip_formatter/step'

module TurnipFormatter
  module Scenario
    include RSpec::Core::BacktraceFormatter

    class NotExistStepsInformationError < ::StandardError; end
    class NoFeatureFileError < ::StandardError; end

    #
    # @param  [RSpec::Core::Example]  example
    #
    def initialize(example)
      @example = example
      clean_backtrace
    end

    def validation
      raise NotExistStepsInformationError unless example.metadata.member?(:turnip)
      raise NoFeatureFileError unless feature_file_path.end_with?('.feature')
    end

    def steps
      @steps ||= descriptions.map do |desc|
        TurnipFormatter::Step.new(example, desc)
      end
    end

    def id
      "step_" + object_id.to_s
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

    def feature_name
      example.example_group.metadata[:example_group][:example_group][:description]
    end

    def feature_file_path
      example.metadata[:file_path]
    end

    def tags
      example.metadata[:turnip][:tags]
    end

    def example
      @example
    end

    private

    def descriptions
      example.metadata[:turnip][:steps]
    end

    def clean_backtrace
      return if example.exception.nil?
      formatted = format_backtrace(example.exception.backtrace, example.metadata)
      new_backtrace = formatted.map { |b| backtrace_line(b) }.compact
      example.exception.set_backtrace(new_backtrace)
    end
  end
end
