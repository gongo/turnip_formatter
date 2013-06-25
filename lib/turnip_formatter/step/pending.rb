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
    end
  end
end
