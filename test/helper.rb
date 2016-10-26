require 'test/unit'
require 'oga'
require 'tempfile'
require 'turnip_formatter/ext/turnip/rspec'

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
    # @param  failed_at [Array<Interger>] Line numbers to assume that test fails
    # @param  feature_file_path [String]
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

      Turnip::RSpec.__send__(:run_feature, rspec_context, feature, filename)
      rspec_context.run(NoopObject.new)
      Turnip::RSpec.update_metadata(feature, rspec_context)

      rspec_context.children.map do |scenario|
        scenario.examples.first
      end
    end
  end
end
