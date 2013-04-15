require 'turnip_formatter/step'

module TurnipFormatter
  module Scenario
    #
    # @param  [RSpec::Core::Example]  example
    #
    def initialize(example)
      @scenario = example
    end

    def steps
      descriptions.map { |desc| TurnipFormatter::Step.new(desc) }
    end

    def method_missing(name, *args, &block)
      if scenario.execution_result.member?(name.to_sym)
        scenario.execution_result[name.to_sym]
      else
        super
      end
    end

    def name
      scenario.example_group.description
    end

    def feature_name
      @scenario.example_group.metadata[:example_group][:example_group][:description]
    end

    def feature_file_path
      scenario.metadata[:file_path]
    end

    def tags
      scenario.metadata[:steps][:tags]
    end

    private

    def scenario
      @scenario
    end

    def descriptions
      descriptions = scenario.metadata[:steps][:descriptions]
      keywords = scenario.metadata[:steps][:keywords]
      docstrings = scenario.metadata[:steps][:docstrings]
      descriptions.zip(keywords, docstrings)
    end
  end
end
