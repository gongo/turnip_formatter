require 'bundler/gem_tasks'
require 'sass'
require 'bootstrap-sass'
require 'rake/testtask'

desc 'Compile report CSS file'
task :compile do
  input = open('lib/turnip_formatter/template/turnip_formatter.scss').read
  engine = Sass::Engine.new(input, syntax: :scss, style: :compressed)

  File.open('lib/turnip_formatter/template/turnip_formatter.css', 'w') do |f|
    f.write engine.render
  end
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test*.rb']
  t.verbose = true
end
