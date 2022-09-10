require 'rexml/document'

module Saxerator
  module Builder
    class XmlBuilder
      attr_reader :name

      def initialize(config, name, attributes)
        @config = config
        @name = name
        @attributes = attributes
        @children = []
        @text = false
      end

      REXML_ENCODING = 'UTF-8'
      def add_node(node)
        if node.is_a? String
          @text = true 
          node.encode!(REXML_ENCODING) unless node.encoding.name == REXML_ENCODING
        end
        @children << node
      end

      def to_xml(builder)
        element = REXML::Element.new(name, nil, attribute_quote: :quote)
        element.add_attributes(@attributes)
        if @text
          element.add_text(@children.join)
        else
          @children.each { |child| child.to_xml(element) }
        end
        builder.elements << element
      end

      def block_variable
        builder = REXML::Document.new
        builder << REXML::XMLDecl.new('1.0', 'UTF-8')
        to_xml(builder)
        builder
      end
    end
  end
end
