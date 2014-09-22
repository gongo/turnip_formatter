require 'bundler/gem_tasks'
require 'sass'
require 'bootstrap-sass'

desc 'Compile report CSS file'
task :compile do
  input = open('lib/turnip_formatter/template/turnip_formatter.scss').read
  engine = Sass::Engine.new(input, syntax: :scss, style: :compressed)

  File.open('lib/turnip_formatter/template/turnip_formatter.css', 'w') do |f|
    f.write engine.render
  end
end
