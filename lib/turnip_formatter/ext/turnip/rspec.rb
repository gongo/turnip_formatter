# -*- coding: utf-8 -*-

require 'turnip/rspec'

module Turnip
  module RSpec
    module Execute
      def run_step(feature_file, step, index)
        begin
          step(step)
        rescue Turnip::Pending
          example.metadata[:line_number] = step.line
          pending("No such step(#{index}): '#{step}'")
        rescue StandardError => e
          example.metadata[:line_number] = step.line
          e.backtrace.push "#{feature_file}:#{step.line}:in step:#{index} `#{step.description}'"
          raise e
        end
      end

      def push_scenario_metadata(scenario)
        steps = scenario.steps
        example.metadata[:turnip_formatter].tap do |turnip|
          steps.each do |step|
            turnip[:steps] << {
              name: step.description,
              extra_args: step.extra_args,
              keyword: step.keyword
            }
          end
          turnip[:tags] += scenario.tags if scenario.respond_to?(:tags)
        end
      end
    end

    class << self
      def run(feature_file)
        Turnip::Builder.build(feature_file).features.each do |feature|
          describe feature.name, feature.metadata_hash do
            let(:backgrounds) do
              feature.backgrounds
            end

            let(:background_steps) do
              backgrounds.map(&:steps).flatten
            end

            before do
              example.metadata[:file_path] = feature_file
              example.metadata[:turnip_formatter] = { steps: [], tags: feature.tags }

              backgrounds.each do |background|
                push_scenario_metadata(background)
              end

              background_steps.each.with_index do |step, index|
                run_step(feature_file, step, index)
              end
            end

            feature.scenarios.each do |scenario|
              describe scenario.name, scenario.metadata_hash do
                before do
                  push_scenario_metadata(scenario)
                end

                it scenario.steps.map(&:description).join(' -> ') do
                  scenario.steps.each.with_index(background_steps.size) do |step, index|
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
