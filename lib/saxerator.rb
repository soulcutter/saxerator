require 'nokogiri'

Dir.glob('lib/saxerator/**/*.rb').each do |f|
  require f[4..-1]
end

module Saxerator
  extend self

  def parser(xml)
    Saxerator::FullDocument.new(xml)
  end
end
