# -*- coding: utf-8 -*-

require 'turnip/rspec'

module Turnip
  module RSpec
    module Execute
      def run_step(feature_file, step, index)
        begin
          step(step)
        rescue Turnip::Pending
          pending("No such step(#{index}): '#{step}'")
        rescue StandardError => e
          e.backtrace.push "#{feature_file}:#{step.line}:in step:#{index} `#{step.description}'"
          raise e
        end
      end

      def initialize_scenario_metadata
        example.metadata[:steps] = {
          descriptions: [],
          docstrings: [],
          keywords: [],
          tags: [],
        }
      end

      def push_scenario_metadata(scenario)
        steps = scenario.steps
        example.metadata[:steps].tap do |meta|
          meta[:descriptions] += steps.map(&:description)
          meta[:docstrings]   += steps.map(&:extra_args)
          meta[:keywords]     += steps.map(&:keyword)
          meta[:tags]          = scenario.tags if scenario.respond_to?(:tags)
        end
      end
    end

    class << self
      def run(feature_file)
        Turnip::Builder.build(feature_file).features.each do |feature|
          describe feature.name, feature.metadata_hash do
            before do
              example.metadata[:file_path] = feature_file
              initialize_scenario_metadata

              feature.backgrounds.each do |background|
                push_scenario_metadata(background)
              end

              feature.backgrounds.map(&:steps).flatten.each.with_index do |step, index|
                run_step(feature_file, step, index)
              end
            end
            feature.scenarios.each do |scenario|
              describe scenario.name, scenario.metadata_hash do
                before do
                  push_scenario_metadata(scenario)
                end

                it scenario.steps.map(&:description).join(' -> ') do
                  scenario.steps.each.with_index do |step, index|
                    run_step(feature_file, step, index)
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
