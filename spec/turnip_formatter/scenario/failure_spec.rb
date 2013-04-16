require 'spec_helper'

module TurnipFormatter::Scenario
  describe Failure do
    let(:scenario) { ::TurnipFormatter::Scenario::Failure.new(failure_example) }
    include_context 'turnip_formatter passed scenario metadata'

    context 'Turnip example' do
      include_context 'turnip_formatter scenario setup', proc {
        expect(true).to be_false
      }

      let(:failure_example) do
        example.exception.backtrace.push ":in step:0 `"
        example
      end

      describe '#validation' do
        it 'should not raise exception' do
          expect { scenario.validation }.not_to raise_error
        end
      end
    end

    context 'Not Turnip example' do
      let(:failure_example) do
        example
      end

      context 'Not failed example' do
        include_context 'turnip_formatter scenario setup', proc {
          expect(true).to be_true
        }

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NotFailedScenarioError
          end
        end        
      end

      context 'Not exist failed step information' do
        include_context 'turnip_formatter scenario setup', proc {
          expect(true).to be_false
        }

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NoExistFailedStepInformationError
          end
        end        
      end
    end
  end
end
