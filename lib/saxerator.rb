require "saxerator/version"
require 'saxerator/configuration'
require 'saxerator/attributes'
require 'saxerator/string_with_attributes'
require 'saxerator/xml_node'
require 'saxerator/parser/nokogiri'
require 'saxerator/hash_with_attributes'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::Configuration.new(xml)
  end
end
