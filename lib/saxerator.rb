require 'saxerator/version'

require 'nokogiri'

require 'saxerator/full_document'
require 'saxerator/document_fragment'

require 'saxerator/builder/string_element'
require 'saxerator/builder/hash_element'
require 'saxerator/builder/array_element'
require 'saxerator/builder/hash_builder'

require 'saxerator/parser/hash_accumulator'
require 'saxerator/parser/latched_accumulator'

require 'saxerator/latches/for_tags'
require 'saxerator/latches/at_depth'
require 'saxerator/latches/within'
require 'saxerator/latches/child_of'
require 'saxerator/latches/with_attributes'

module Saxerator
  extend self

  def parser(xml)
    Saxerator::FullDocument.new(xml)
  end
end
