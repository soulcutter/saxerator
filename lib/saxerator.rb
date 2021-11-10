require 'saxerator/version'

require 'saxerator/sax_handler'
require 'saxerator/dsl'
require 'saxerator/full_document'
require 'saxerator/document_fragment'
require 'saxerator/hash_key_processor'
require 'saxerator/configuration'

require 'saxerator/builder'
require 'saxerator/builder/array_element'
require 'saxerator/builder/hash_element'
require 'saxerator/builder/string_element'
require 'saxerator/builder/hash_builder'
require 'saxerator/builder/xml_builder'

require 'saxerator/parser/accumulator'
require 'saxerator/parser/latched_accumulator'

require 'saxerator/latches/for_tags'
require 'saxerator/latches/at_depth'
require 'saxerator/latches/within'
require 'saxerator/latches/child_of'
require 'saxerator/latches/with_attributes'

module Saxerator
  class ParseException < StandardError
  end

  extend self

  def parser(xml)
    config = Configuration.new
    yield(config) if block_given?

    FullDocument.new(xml, config)
  end
end
