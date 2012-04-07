require "saxerator/version"
require 'saxerator/configuration'
require 'saxerator/xml_node'
require 'saxerator/parser/nokogiri'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::Configuration.new(xml)
  end
end
