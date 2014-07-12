# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'turnip_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = "turnip_formatter"
  spec.version       = TurnipFormatter::VERSION
  spec.authors       = ["Wataru MIYAGUNI"]
  spec.email         = ["gonngo@gmail.com"]
  spec.description   = %q{RSpec custom formatter for Turnip}
  spec.summary       = %q{RSpec custom formatter for Turnip}
  spec.homepage      = "https://github.com/gongo/turnip_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'turnip', '~> 1.2.2'
  spec.add_dependency 'tilt'
  spec.add_dependency 'haml'
  spec.add_dependency 'sass'
  spec.add_dependency 'bootstrap-sass'
  spec.add_dependency 'rspec', '~> 2.14.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec-html-matchers'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard-rspec'
end
