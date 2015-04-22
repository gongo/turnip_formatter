require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec/'
  add_filter 'vendor/'
  add_filter 'lib/turnip_formatter/ext'
end

require 'turnip_formatter'
Dir.glob(File.dirname(__FILE__) + '/support/**/*.rb') { |f| require(f) }

class NoopObject
  def method_missing(name, *args, &block)
    # nooooooop
  end
end

RSpec.configure do |config|
  config.include ExampleHelper
  config.include StepHelper
end
