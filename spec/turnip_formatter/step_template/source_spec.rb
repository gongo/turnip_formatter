# -*- coding: utf-8 -*-

require 'spec_helper'
require 'turnip_formatter/step_template/source'

module TurnipFormatter
  module StepTemplate
    describe Source do
      let(:template) { ::TurnipFormatter::StepTemplate::Source }
      let(:source) { __FILE__ + ':3' }

      describe '.build' do
        subject { template.build(source) }
        it do
          should match '<pre class="source"><code class="ruby">'
          should match "require 'turnip_formatter/step_template/source'"
        end
      end
    end
  end
end
