require 'test/unit'
require 'oga'

def html_parse(str)
  Oga.parse_xml(str)
end

module TurnipFormatter
  module TestHelper
    @@sample_feature = nil

    def sample_step
      sample_feature.scenarios[0].steps[0]
    end

    def sample_step_with_docstring
      sample_feature.scenarios[0].steps[1]
    end

    def sample_step_with_datatable
      sample_feature.scenarios[0].steps[2]
    end

    def sample_feature
      return @@sample_feature if @@sample_feature

      filename = File.expand_path('./sample.feature', File.dirname(__FILE__))
      @@sample_feature = Turnip::Builder.build(filename).features[0]
    end
  end
end
