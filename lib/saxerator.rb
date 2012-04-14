require 'nokogiri'

require "saxerator/version"
require 'saxerator/configuration'
require 'saxerator/string_with_attributes'
require 'saxerator/hash_with_attributes'
require 'saxerator/xml_node'

require 'saxerator/parser/accumulator'
require 'saxerator/parser/document_latch'
require 'saxerator/parser/element_name_latch'
require 'saxerator/parser/latched_accumulator'
require 'saxerator/parser/nokogiri'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::Configuration.new(xml)
  end
end
