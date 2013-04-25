# -*- coding: utf-8 -*-
require 'turnip_formatter/step'
require 'turnip_formatter/step/dsl'

module TurnipFormatter
  class Step
    module Failure
      extend DSL
      
      def self.status
        :failure
      end

      def status
        Failure.status
      end
    end
  end
end

TurnipFormatter::Step::Failure.add_template :source do
  example.exception.backtrace.first
end

TurnipFormatter::Step::Failure.add_template :exception do
  example.exception
end
