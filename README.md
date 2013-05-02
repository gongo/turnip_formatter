RSpec::Core::Formatters::TurnipFormatter
========================================

TurnipFormatter is a pretty custom formatter for [Turnip](https://github.com/jnicklas/turnip).

[![Build Status](https://travis-ci.org/gongo/turnip_formatter.png?branch=master)](https://travis-ci.org/gongo/turnip_formatter)
[![Coverage Status](https://coveralls.io/repos/gongo/turnip_formatter/badge.png?branch=master)](https://coveralls.io/r/gongo/turnip_formatter)
[![Code Climate](https://codeclimate.com/github/gongo/turnip_formatter.png)](https://codeclimate.com/github/gongo/turnip_formatter)
[![Dependency Status](https://gemnasium.com/gongo/turnip_formatter.png)](https://gemnasium.com/gongo/turnip_formatter)

Requirements
--------------------

* Ruby
    * `~> 1.9.3`
    * `~> 2.0.0`

Installation
--------------------

### RubyGems

    $ gem install turnip_formatter

### Bundler

Add this line to your application's Gemfile:

```ruby
group :test do
  gem 'turnip_formatter'
end
```

And then execute:

    $ bundle install

Usage
--------------------

Run this command.

    $ rspec -r turnip_formatter --format RSpecTurnipFormatter --out report.html

Example
--------------------

see https://github.com/gongo/turnip_formatter/tree/master/spec/examples

Add-on
--------------------

* Gnawrnip
    * Gnawrnip is a TurnipFormatter Add-on that provides put a screen shot to report use Capybara
    * https://github.com/gongo/gnawrnip

License
--------------------

see LICENSE.txt
