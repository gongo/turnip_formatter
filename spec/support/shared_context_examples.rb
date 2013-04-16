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
      steps: { descriptions: ['Step 1'], docstrings: [[]], keywords: ['When'], tags: [] },
      file_path: '/path/to/hoge.feature'
    }
  end
end
