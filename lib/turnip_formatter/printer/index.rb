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

        def print_out(params)
          render_template(:index, {
              scenarios:        params[:scenarios],
              failed_count:     params[:failed_count],
              pending_count:    params[:pending_count],
              total_time:       params[:total_time],
              scenario_files:   params[:scenario_files]
            }
          )
          puts 'FAILED' if params[:failed_count] > 0
        end
      end
    end
  end
end
