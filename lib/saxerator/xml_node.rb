module Saxerator
  class XmlNode
    attr_accessor :name, :attributes, :children, :type

    def initialize(parser, name, attributes)
      @parser = parser
      self.name = name
      self.attributes = attributes
      self.children = []
      @text = false
    end

    def add_node(node)
      @text = true if node.is_a? String
      children << node
    end

    def to_hash
      children.join(' ') if @text
    end
  end
end