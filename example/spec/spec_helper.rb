require 'turnip_formatter'

RSpec.configure do |config|
  config.add_formatter RSpecTurnipFormatter, 'report.html'
end

Dir.glob(File.dirname(__FILE__) + '/steps/**/*steps.rb') { |f| load f, true }

RSpec.configure do |config|
  config.before(:example, before_hook_error: true) do
    #
    # Workaround for JRuby <= 9.1.7.0
    #
    # https://github.com/jruby/jruby/issues/4467
    # https://github.com/rspec/rspec-core/pull/2381
    #
    begin
      undefined_method # NameError
    rescue => e
      raise e
    end
  end

  config.after(:example, after_hook_error: true) do
    expect(true).to be false # RSpec Matcher Error
  end
end

# TurnipFormatter.configure do |config|
#   config.title = 'My Report'
#   config.add_stylesheet File.dirname(__FILE__) + '/foo.css'
#   config.add_javascript File.dirname(__FILE__) + '/bar.js'
# end
