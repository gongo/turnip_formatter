require 'forwardable'
require 'turnip_formatter/resource/step/failure_result'
require 'turnip_formatter/resource/step/pending_result'

module TurnipFormatter
  module Resource
    module Step
      class Step
        include ::TurnipFormatter::Resource::Step::FailureResult
        include ::TurnipFormatter::Resource::Step::PendingResult

        extend Forwardable
        def_delegators :@raw, :keyword, :text, :line, :argument

        attr_reader :example

        #
        # @param  [RSpec::Core::Example]  example
        # @param  [Turnip::Node::Step]    raw
        #
        def initialize(example, raw)
          @example = example
          @raw = raw
          @executed = false
        end

        def mark_as_executed
          @executed = true
        end

        def executed?
          @executed
        end

        def status
          case
          when failed?
            :failed
          when pending?
            :pending
          when executed?
            :passed
          else
            :unexecute
          end
        end
      end
    end
  end
end
