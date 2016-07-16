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
end

require 'saxerator'
