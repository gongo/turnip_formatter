shared_context "turnip_formatter scenario setup" do |proc|
  let(:example) do
    group = ::RSpec::Core::ExampleGroup.describe('Feature').describe('Scenario')
    _example = group.example('example', metadata, &proc)
    group.run(NoopObject.new)
    _example
  end
end

shared_context 'turnip_formatter passed scenario metadata' do
  let(:metadata) do
    {
      turnip: {
        steps: [ { name: 'Step 1', extra_args: [], keyword: 'When' } ],
        tags: []
      },
      file_path: '/path/to/hoge.feature'
    }
  end
end

shared_context 'turnip_formatter standard step parameters' do
  let(:description) do
    { name: 'StepName', keyword: 'Keyword', extra_args: ['Docstring'] }
  end
end
