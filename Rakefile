require 'rake/dsl_definition'
require 'bundler/gem_tasks'

# rspec
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

# cucumber
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "--format pretty"
end

desc "delete generated files"
task :clobber do
  sh 'rm -rf pkg'
  sh 'rm -rf tmp'
  sh 'rm -rf coverage'
end

desc "Push docs/cukes to relishapp using the relish-client-gem"
task :relish, :version do |t, args|
  raise "rake relish[VERSION]" unless args[:version]
  if `relish versions soulcutter/saxerator`.split.map(&:strip).include? args[:version]
    puts "Version #{args[:version]} already exists"
  else
    sh "relish versions:add soulcutter/saxerator:#{args[:version]}"
  end
  sh "relish push soulcutter/saxerator:#{args[:version]}"
end



task :default => [:spec, :features]