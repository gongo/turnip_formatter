# -*- coding: utf-8 -*-

require 'rspec'
require 'rspec/core/formatters/base_formatter'
require 'turnip_formatter/renderer/html/index'
require 'turnip_formatter/resource/scenario/pass'
require 'turnip_formatter/resource/scenario/failure'
require 'turnip_formatter/resource/scenario/pending'

module RSpec
  module Core
    module Formatters
      class TurnipFormatter < BaseFormatter
        attr_accessor :scenarios, :failure_count, :pending_count

        Formatters.register self, :example_passed, :example_pending, :example_failed, :dump_summary

        def self.formatted_backtrace(example, exception = nil)
          exception = example.exception if exception.nil?
          formatter = RSpec.configuration.backtrace_formatter
          formatter.format_backtrace(exception.backtrace, example.metadata)
        end

        def initialize(output)
          super(output)
          @scenarios = []
          @failure_count = 0
          @pending_count = 0
        end

        def dump_summary(summary)
          print_params = {
            scenarios:      scenarios,
            failed_count:   failure_count,
            pending_count:  pending_count,
            total_time:     summary.duration
          }
          output_html(print_params)
        end

        def example_passed(notification)
          return unless notification.example.metadata[:type] == :feature

          scenario = ::TurnipFormatter::Resource::Scenario::Pass.new(notification.example)
          scenarios << scenario
        end

        def example_pending(notification)
          return unless notification.example.metadata[:type] == :feature

          @pending_count +=1
          scenario = ::TurnipFormatter::Resource::Scenario::Pending.new(notification.example)
          scenarios << scenario
        end

        def example_failed(notification)
          return unless notification.example.metadata[:type] == :feature

          @failure_count +=1
          scenario = ::TurnipFormatter::Resource::Scenario::Failure.new(notification.example)
          scenarios << scenario
        end

        private

        def output_html(params)
          output.puts ::TurnipFormatter::Renderer::Html::Index.new(params).render
        end
      end
    end
  end
end
