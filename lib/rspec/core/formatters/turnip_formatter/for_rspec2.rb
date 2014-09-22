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
            output_html(print_params)
          end

          def example_passed(example)
            scenario = ::TurnipFormatter::Scenario::Pass.new(example)
            output_scenario(scenario)
          end

          def example_pending(example)
            scenario = ::TurnipFormatter::Scenario::Pending.new(example)
            output_scenario(scenario)
          end

          def example_failed(example)
            scenario = ::TurnipFormatter::Scenario::Failure.new(example)
            output_scenario(scenario)
          end

          module Helper
            def formatted_backtrace(example)
              RSpec::Core::BacktraceFormatter.format_backtrace(example.exception.backtrace, example.metadata)
            end
          end
        end
      end
    end
  end
end
