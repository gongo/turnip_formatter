require 'bundler/gem_tasks'
require 'sass'
require 'bootstrap-sass'
require 'rake/testtask'

desc 'Compile report CSS file'
task :compile do
  dir = 'lib/turnip_formatter/renderer/html/assets'
  input = open("#{dir}/turnip_formatter.scss").read
  engine = Sass::Engine.new(input, syntax: :scss, style: :compressed)

  File.open("#{dir}/turnip_formatter.css", 'w') do |f|
    f.write engine.render
  end
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
  t.warning = false
end
