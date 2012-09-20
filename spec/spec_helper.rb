if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "spec/"
  end
end

Dir['./spec/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.include FixtureFile
end

require 'saxerator'