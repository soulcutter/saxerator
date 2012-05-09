require 'saxerator/version'

require 'saxerator/full_document'
require 'saxerator/document_fragment'
require 'saxerator/string_with_attributes'
require 'saxerator/hash_with_attributes'
require 'saxerator/xml_node'

require 'saxerator/parser/accumulator'
require 'saxerator/parser/element_name_latch'
require 'saxerator/parser/depth_latch'
require 'saxerator/parser/within_element_latch'
require 'saxerator/parser/latched_accumulator'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::FullDocument.new(xml)
  end
end
