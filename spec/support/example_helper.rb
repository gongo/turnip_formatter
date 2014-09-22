module ExampleHelper
  def passed_example
    base_example { expect(true).to be true }
  end

  def failed_example
    base_example { expect(true).to be false }
  end

  def pending_example
    example = if ::RSpec::Version::STRING >= '2.99.0'
                base_example { skip('No such step(0): ') }
              else
                base_example { pending('No such step(0): ') }
              end

    # Turnip::Rspec::Execute#run_step
    example.metadata[:line_number] = 10
    example.metadata[:location] = "#{example.metadata[:file_path]}:10"
    example
  end

  private

    def base_example(&assertion)
      group = ::RSpec::Core::ExampleGroup.describe('Feature').describe('Scenario')
      example = group.example('example', example_metadata, &assertion)
      example.metadata[:file_path] = '/path/to/hoge.feature'

      instance_eval <<-EOS, example.metadata[:file_path], 10
        group.run(NoopObject.new)
      EOS

      example
    end

    def example_metadata
      {
        turnip_formatter: {
          steps: [Turnip::Builder::Step.new('Step 1', [], 1, 'When')],
          tags: []
        }
      }
    end
end
