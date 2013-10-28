require 'turnip_formatter'

RSpec.configure do |config|
  config.project_name = "My project"
  config.add_formatter RSpecTurnipFormatter, 'report.html'
end

Dir.glob(File.dirname(__FILE__) + "/steps/**/*steps.rb") { |f| load f, true }
