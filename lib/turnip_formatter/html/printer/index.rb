require 'turnip_formatter/html/printer'
require 'turnip_formatter/html/printer/scenario'
require 'turnip_formatter/html/printer/tab_feature_statistics'
require 'turnip_formatter/html/printer/tab_tag_statistics'
require 'turnip_formatter/html/printer/tab_speed_statistics'

module TurnipFormatter
  module Html
    module Printer
      class Index
        class << self
          include TurnipFormatter::Html::Printer

          def print_out(params)
            render_template(:index, {
                scenarios:        params[:scenarios],
                failed_count:     params[:failed_count],
                pending_count:    params[:pending_count],
                total_time:       params[:total_time],
                scenario_files:   params[:scenario_files]
              }
              )
          end
        end
      end
    end
  end
end
