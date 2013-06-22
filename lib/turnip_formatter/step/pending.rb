# -*- coding: utf-8 -*-
require 'turnip_formatter/step'
require 'turnip_formatter/step/dsl'

module TurnipFormatter
  class Step
    module Pending
      extend DSL

      def self.status
        :pending
      end

      def status
        Pending.status
      end

      add_template :exception do
        message = example.execution_result[:pending_message]
        exception = RSpec::Core::Pending::PendingDeclaredInExample.new(message)
        exception.set_backtrace(example.location)
        exception
      end
    end
  end
end
