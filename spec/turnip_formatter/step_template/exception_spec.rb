# -*- coding: utf-8 -*-

require 'spec_helper'
require 'turnip_formatter/step_template/exception'

module TurnipFormatter
  module StepTemplate
    describe Exception do
      let(:template) { ::TurnipFormatter::StepTemplate::Exception }
      let(:exception) do
        StandardError.new('StepExceptionError').tap do |e|
          e.set_backtrace(['/path/to/error.rb: 10'])
        end
      end

      describe '.build' do
        subject { template.build(exception) }
        it do
          should match %r{div class="step_exception"}
          should match %r{<pre>.*#{exception.message}.*</pre>}
          should match %r{<li>/path/to/error.rb: 10</li>}
        end
      end
    end
  end
end
