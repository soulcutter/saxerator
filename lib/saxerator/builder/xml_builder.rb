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

      def add_node(node)
        @text = true if node.is_a? String
        @children << node
      end

      def to_xml(builder)
        if @text
          builder.send("#{name}_", @attributes, @children.join)
        else
          builder.send("#{name}_", @attributes) do |xml|
            @children.each { |child| child.to_xml(xml) }
          end
        end
      end

      def block_variable
        builder = Nokogiri::XML::Builder.new
        to_xml(builder)
        builder.doc
      end
    end
  end
end