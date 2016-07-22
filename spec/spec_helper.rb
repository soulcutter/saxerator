if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "spec/"
  end
end

require 'support/fixture_file'

RSpec.configure do |config|
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.include FixtureFile

  config.before(:suite) do |example|
    return unless adapter = ENV["SAXERATOR_ADAPTER"]
    puts "Using '#{adapter}' for parsing"
  end

  config.before do |example|
    adapter = ENV["SAXERATOR_ADAPTER"]

    if adapter && !example.metadata[:nokogiri_only]
      require "saxerator/configuration"
      require "saxerator/adapters/#{adapter}"
      adapter = Saxerator::Adapters.const_get(adapter.capitalize, false)

      allow_any_instance_of(Saxerator::Configuration).to receive(:adapter) { adapter }
    end
  end
end

require 'saxerator'
