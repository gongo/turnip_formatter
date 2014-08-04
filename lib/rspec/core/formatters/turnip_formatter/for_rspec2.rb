# -*- coding: utf-8 -*-

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        module ForRSpec2
          def dump_summary(duration, _, failure_count, pending_count)
            print_params = {
              scenarios:      scenarios,
              failed_count:   failure_count,
              pending_count:  pending_count,
              total_time:     duration,
              scenario_files: scenario_output_files
            }
            output_summary(print_params)
          end

          def example_passed(example)
            scenario = ::TurnipFormatter::Scenario::Pass.new(example)
            output_scenario(scenario)
          end

          def example_pending(example)
            clean_backtrace(example)
            scenario = ::TurnipFormatter::Scenario::Pending.new(example)
            output_scenario(scenario)
          end

          def example_failed(example)
            clean_backtrace(example)
            scenario = ::TurnipFormatter::Scenario::Failure.new(example)
            output_scenario(scenario)
          end

          private

          def clean_backtrace(example)
            return if example.exception.nil?
            formatted = format_backtrace(example.exception.backtrace, example)
            example.exception.set_backtrace(formatted)
          end
        end
      end
    end
  end
end
