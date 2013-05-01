require 'spec_helper'

module TurnipFormatter
  describe Step do
    include_context 'turnip_formatter standard step parameters'
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter passed scenario metadata'
    let(:step) { ::TurnipFormatter::Step.new(example, description) }

    describe '#attention?' do
      subject { step.attention? }
      it { should be_false }
    end

    describe '#name' do
      subject { step.name }
      it { should eq('KeywordStepName') }
    end

    describe '#docs' do
      subject { step.docs }
      it { should include :extra_args }
    end

    describe '#add_template' do
      let :custom_template do
        Module.new do
          def self.build(hoge)
            hoge * 3
          end
        end
      end

      before do
        TurnipFormatter::Step.add_template :hoge, :source1 do
          'aiueo'
        end

        TurnipFormatter::Step.add_template :hoge, :source2, custom_template do
          '12345'
        end
      end

      after do
        TurnipFormatter::Step.remove_template(:hoge, :source1)
        TurnipFormatter::Step.remove_template(:hoge, :source2)
      end

      it 'can add step template' do
        style = TurnipFormatter::Step.templates[:hoge][:source1]
        expect(style[:block].call).to eq('aiueo')

        style = TurnipFormatter::Step.templates[:hoge][:source2]
        expect(style[:klass].build(style[:block].call)).to eq('123451234512345')
      end
    end

    describe '#remove_template' do
      it 'can remove step template' do
        TurnipFormatter::Step.add_template :hoge, :style1 do ; 'aiueo' end
        TurnipFormatter::Step.add_template :hoge, :style2 do ; '12345' end
        expect(TurnipFormatter::Step.templates[:hoge]).to have_key :style1
        expect(TurnipFormatter::Step.templates[:hoge]).to have_key :style2

        TurnipFormatter::Step.remove_template(:hoge, :style1)
        expect(TurnipFormatter::Step.templates[:hoge]).to have_key :style2

        TurnipFormatter::Step.remove_template(:hoge, :style2)
        expect(TurnipFormatter::Step.templates).not_to have_key(:hoge)
      end
    end
  end
end
