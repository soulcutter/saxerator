if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter "spec/"
  end
end

require 'saxerator'