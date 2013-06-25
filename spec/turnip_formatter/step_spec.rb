require 'spec_helper'

module TurnipFormatter
  describe Step do
    include_context 'turnip_formatter standard step parameters'
    include_context 'turnip_formatter scenario setup'
    include_context 'turnip_formatter standard scenario metadata'
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

    context 'using template' do
      let :custom_template1 do
        Module.new do
          def self.build(hoge)
            hoge * 3
          end
        end
      end

      let :custom_template2 do
        Module.new do
          def self.build(hoge)
            'aiueo' + hoge
          end
        end
      end

      before do
        TurnipFormatter::Step.add_template :hoge, custom_template1 do
          '12345'
        end

        TurnipFormatter::Step.add_template :hoge, custom_template2 do
          'abcde'
        end
      end

      after do
        TurnipFormatter::Step.remove_template(:hoge, custom_template1)
        TurnipFormatter::Step.remove_template(:hoge, custom_template2)
      end

      describe '#add_template' do
        it 'can add step template' do
          style1 = TurnipFormatter::Step.templates[:hoge][custom_template1]
          klass1 = style1[:klass]
          block1 = style1[:block]
          expect(klass1.build(block1.call)).to eq('123451234512345')

          style2 = TurnipFormatter::Step.templates[:hoge][custom_template2]
          klass2 = style2[:klass]
          block2 = style2[:block]
          expect(klass2.build(block2.call)).to eq('aiueoabcde')
        end
      end

      describe '#remove_template' do
        it 'can remove step template' do
          expect(TurnipFormatter::Step.templates[:hoge]).to have_key custom_template1
          expect(TurnipFormatter::Step.templates[:hoge]).to have_key custom_template2

          TurnipFormatter::Step.remove_template(:hoge, custom_template1)
          expect(TurnipFormatter::Step.templates[:hoge]).not_to have_key custom_template1
          expect(TurnipFormatter::Step.templates[:hoge]).to have_key custom_template2

          TurnipFormatter::Step.remove_template(:hoge, custom_template2)
          expect(TurnipFormatter::Step.templates).not_to have_key custom_template2
        end
      end
    end
  end
end
