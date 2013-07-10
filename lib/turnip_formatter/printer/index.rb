require 'turnip_formatter/printer'
require 'turnip_formatter/printer/scenario'
require 'turnip_formatter/printer/tab_feature_statistics'
require 'turnip_formatter/printer/tab_tag_statistics'
require 'turnip_formatter/printer/tab_speed_statistics'

module TurnipFormatter
  module Printer
    class Index
      class << self
        include TurnipFormatter::Printer

        #
        # @param  RSpec::Core::Formatters::TurnipFormatter  formatter
        #
        def print_out(formatter)
          render_template(:index, {
              scenarios:        formatter.scenarios,
              passed_scenarios: formatter.passed_scenarios,
              failed_count:     formatter.failure_count,
              pending_count:    formatter.pending_count,
              total_time:       formatter.duration,
            }
          )
        end
      end
    end
  end
end
