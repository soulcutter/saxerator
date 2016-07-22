require 'rake/dsl_definition'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

require 'pry'

namespace :spec do
  desc "Run specs against all available adapters"
  task :adapters do |t|
    %w(nokogiri ox).each do |adapter|
      ENV["SAXERATOR_ADAPTER"] = adapter
      Rake::Task['spec'].invoke
      ::Rake.application['spec'].reenable
    end
  end
end
