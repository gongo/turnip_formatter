require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'spec/'
  add_filter 'vendor/'
end

require 'turnip_formatter'
Dir.glob(File.dirname(__FILE__) + "/support/**/*.rb") { |f| require(f) }

# require 'coveralls'
# Coveralls.wear!

class NoopObject
  def method_missing(name, *args, &block)
    # nooooooop
  end
end
