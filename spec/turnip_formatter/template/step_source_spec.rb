require 'spec_helper'
require 'turnip_formatter/template/step_source'

module TurnipFormatter
  class Template
    describe StepSource do
      let(:template) { ::TurnipFormatter::Template::StepSource }
      let(:source) { __FILE__ + ':1' }

      describe '.build' do
        subject { template.build(source) }
        it do
          should match '<pre class="source"><code class="ruby">'
          should match "require 'turnip_formatter/template/step_source'"
        end
      end
    end
  end
end
