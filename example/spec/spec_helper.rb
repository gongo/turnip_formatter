require 'turnip_formatter'

RSpec.configure do |config|
  c.add_setting :project_name, :default => "My project"
  config.add_formatter RSpecTurnipFormatter, 'report.html'
end

Dir.glob(File.dirname(__FILE__) + "/steps/**/*steps.rb") { |f| load f, true }
