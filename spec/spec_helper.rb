if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'spec/'
  end
end

require 'support/fixture_file'

RSpec.configure do |config|
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.include FixtureFile

  adapter = ENV['SAXERATOR_ADAPTER']

  config.before(:suite) do |_|
    unless adapter
      puts 'SAXERATOR_ADAPTER weren\'t defined'
      next
    end
    puts "Using '#{adapter}' for parsing"
  end

  config.before do |example|
    if adapter && !example.metadata[:nokogiri_only]
      require 'saxerator/configuration'
      require "saxerator/adapters/#{adapter}"
      adapter_class = Saxerator::Adapters.const_get(adapter.capitalize, false)

      allow_any_instance_of(Saxerator::Configuration).to receive(:adapter) { adapter_class }
    end
  end
end

require 'saxerator'
