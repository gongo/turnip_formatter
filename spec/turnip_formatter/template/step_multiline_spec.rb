# -*- coding: utf-8 -*-

require 'spec_helper'
require 'turnip_formatter/template/step_multiline'

module TurnipFormatter
  class Template
    describe StepMultiline do
      let(:template) { ::TurnipFormatter::Template::StepMultiline }
      let(:string) { 'a<a>a' }

      describe '.build' do
        subject { template.build(string) }
        it { should eq '<pre class="multiline">a&lt;a&gt;a</pre>' }
      end
    end
  end
end
