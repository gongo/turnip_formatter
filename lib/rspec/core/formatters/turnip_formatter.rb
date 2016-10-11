# -*- coding: utf-8 -*-

require 'rspec'
require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/scenario/pass'
require 'turnip_formatter/scenario/failure'
require 'turnip_formatter/scenario/pending'
require 'turnip_formatter/printer/index'
require 'turnip_formatter/printer/scenario'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_accessor :scenarios

        Formatters.register self, :example_passed, :example_pending, :example_failed, :dump_summary

        def self.formatted_backtrace(example)
          formatter = RSpec.configuration.backtrace_formatter
          formatter.format_backtrace(example.exception.backtrace, example.metadata)
        end

        def initialize(output)
          super(output)
          @scenarios = []
        end

        def dump_summary(summary)
          print_params = {
            scenarios:      scenarios,
            failed_count:   summary.failure_count,
            pending_count:  summary.pending_count,
            total_time:     summary.duration
          }
          output_html(print_params)
        end

        def example_passed(notification)
          scenario = ::TurnipFormatter::Scenario::Pass.new(notification.example)
          scenarios << scenario
        end

        def example_pending(notification)
          scenario = ::TurnipFormatter::Scenario::Pending.new(notification.example)
          scenarios << scenario
        end

        def example_failed(notification)
          scenario = ::TurnipFormatter::Scenario::Failure.new(notification.example)
          scenarios << scenario
        end

        private

        def output_html(params)
          output.puts ::TurnipFormatter::Printer::Index.print_out(params)
        end
      end
    end
  end
end
