shared_context "turnip_formatter scenario setup" do |assertion|
  let(:example) do
    assertion ||= proc { expect(true).to be true }
    group = ::RSpec::Core::ExampleGroup.describe('Feature').describe('Scenario')
    example = group.example('example', metadata, &assertion)
    group.run(NoopObject.new)
    example
  end
end

shared_context "turnip_formatter failure scenario setup" do |assertion|
  include_context 'turnip_formatter scenario setup', proc {
    expect(true).to be false
  }
end

shared_context "turnip_formatter pending scenario setup" do |assertion|
  include_context 'turnip_formatter scenario setup', proc {
    pending('Pending')
  }
end

shared_context 'turnip_formatter standard scenario metadata' do
  let(:metadata) do
    {
      turnip_formatter: {
        steps: [ { name: 'Step 1', extra_args: [], keyword: 'When' } ],
        tags: []
      },
      file_path: '/path/to/hoge.feature'
    }
  end
end
