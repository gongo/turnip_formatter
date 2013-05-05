guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

guard 'rspec', cli: '-r ./spec/examples/spec_helper' do
  watch('lib/turnip_formatter/formatter.css')  { "spec/examples" }
end
