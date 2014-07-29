# -*- coding: utf-8 -*-

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        module ForRSpec3
          def dump_summary(summary)
            print_params = {
              scenarios:      scenarios,
              failed_count:   summary.failure_count,
              pending_count:  summary.pending_count,
              total_time:     summary.duration,
              scenario_files: scenario_output_files
            }
            output_html(print_params)
          end

          def example_passed(notification)
            scenario = ::TurnipFormatter::Scenario::Pass.new(notification.example)
            output_scenario(scenario)
          end

          def example_pending(notification)
            clean_backtrace(notification)
            scenario = ::TurnipFormatter::Scenario::Pending.new(notification.example)
            output_scenario(scenario)
          end

          def example_failed(notification)
            clean_backtrace(notification)
            scenario = ::TurnipFormatter::Scenario::Failure.new(notification.example)
            output_scenario(scenario)
          end

          private

          def clean_backtrace(notification)
            if notification.respond_to?(:formatted_backtrace)
              formatted = notification.formatted_backtrace
              notification.example.exception.set_backtrace(formatted)
            end
          end
        end
      end
    end
  end
end
