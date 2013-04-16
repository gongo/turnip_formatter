require 'spec_helper'

module TurnipFormatter::Scenario
  describe Failure do
    let(:scenario) { ::TurnipFormatter::Scenario::Pending.new(pending_example) }

    let(:pending_example) do
      example.execution_result[:pending_message] = 'No such step(0): '
      example
    end

    include_context 'turnip_formatter passed scenario metadata'

    context 'Turnip example' do
      include_context 'turnip_formatter scenario setup', proc {
        pending('Pending')
      }

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

      context 'Not pending example' do
        include_context 'turnip_formatter scenario setup', proc {
          expect(true).to be_true
        }

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NotPendingScenarioError
          end
        end        
      end

      context 'Not exist pending step information' do
        include_context 'turnip_formatter scenario setup', proc {
          pending('Pending')
        }

        let(:pending_example) do
          example
        end

        describe '#validation' do
          it 'should raise exception' do
            expect { scenario.validation }.to raise_error NoExistPendingStepInformationError
          end
        end        
      end
    end
  end
end
