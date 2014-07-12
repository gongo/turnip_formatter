require 'turnip_formatter'

RSpec.configure do |config|
  config.project_name = 'My project'
  config.add_formatter RSpecTurnipFormatter, 'report.html'
end

Dir.glob(File.dirname(__FILE__) + '/steps/**/*steps.rb') { |f| load f, true }

# TurnipFormatter.configure do |config|
#   config.add_stylesheet File.dirname(__FILE__) + '/foo.css'
#   config.add_javascript File.dirname(__FILE__) + '/bar.js'
# end
