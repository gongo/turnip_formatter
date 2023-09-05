require 'test/unit'
require 'oga'
require 'tempfile'
require 'turnip_formatter/ext/turnip/rspec'
require 'turnip_formatter/resource/scenario/failure'
require 'turnip_formatter/resource/scenario/pending'

if ENV['COVERALLS_REPO_TOKEN']
  require 'coveralls'
  Coveralls.wear!('test_frameworks')
end

def html_parse(str)
  Oga.parse_xml(str)
end

module TurnipFormatter
  module TestHelper
    class NoopObject
      def method_missing(name, *args, &block)
        # nooooooop
      end
    end

    def dummy_failed_step
      feature = feature_build(<<-EOS)
        Feature: feature
          Scenario: Failed
            When [ERROR]
      EOS

      TurnipFormatter::Resource::Scenario::Failure.new(
        run_feature(feature, '/path/to/test.feature').first
      ).steps[0]
    end

    def dummy_pending_step
      feature = feature_build(<<-EOS)
        Feature: feature
          Scenario: Pending
            When [PENDING]
      EOS
      TurnipFormatter::Resource::Scenario::Pending.new(
        run_feature(feature, '/path/to/test.feature').first
      ).steps[0]
    end

    #
    # @param text [String]  feature text
    # @return [Turnip::Node::Feature]
    #
    def feature_build(text)
      Tempfile.create(['turnip_formatter_test', '.feature']) do |f|
        f.write(text)
        f.flush
        Turnip::Builder.build(f.path)
      end
    end

    #
    # Override Turnip::Execute#step
    #
    module ExecuteWrapper
      def step(s)
        case s.text
        when /^\[ERROR\]/
          expect(true).to be false
        when /^\[PENDING\]/
          raise Turnip::Pending
        else
          expect(true).to be true
        end
      end
    end

    #
    # Emulate Turnip::RSpec#run_feature
    #
    # @param  feature [Turnip::Node::Feature]
    # @param  filename [String]
    #
    # @return [Array<RSpec::Core::Example>] Array of example for scenarios.
    #
    #  e.g.:
    #
    #    Feature: ...
    #      Scenario: xxx
    #        When I
    #        Then do
    #      Scenario: yyy
    #        When He
    #        Then do
    #
    #    # => [<RSpec::Core::Example "I->do">, <RSpec::Core::Example "He->do">]
    #
    # @see {Turnip::RSpec.run_feature}
    #
    def run_feature(feature, filename)
      rspec_context = ::RSpec::Core::ExampleGroup.describe(feature.name)
      rspec_context.include(Turnip::RSpec::Execute)
      rspec_context.include(ExecuteWrapper)

      rspec_context.before(:example, before_hook_error: true) do
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

      rspec_context.after(:example, after_hook_error: true) do
        expect(true).to be false # RSpec Matcher Error
      end

      Turnip::RSpec.__send__(:run_feature, rspec_context, feature, filename)
      rspec_context.run(NoopObject.new)
      Turnip::RSpec.update_metadata(feature, rspec_context)

      rspec_context.children.map do |scenario|
        scenario.examples.first
      end
    end
  end
end
