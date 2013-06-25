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
