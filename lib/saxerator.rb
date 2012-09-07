require 'saxerator/version'

require 'saxerator/full_document'
require 'saxerator/document_fragment'
require 'saxerator/string_element'
require 'saxerator/hash_element'
require 'saxerator/xml_node'

require 'saxerator/parser/accumulator'
require 'saxerator/parser/for_tags_latch'
require 'saxerator/parser/at_depth_latch'
require 'saxerator/parser/within_latch'
require 'saxerator/parser/latched_accumulator'
require 'saxerator/parser/child_of_latch'
require 'saxerator/parser/with_attributes_latch'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::FullDocument.new(xml)
  end
end
