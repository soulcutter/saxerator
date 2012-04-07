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
      if @text
        return children.join(' ')
      else
        out = {}
        @children.each do |child|
          name = child.name
          if out[name]
            if !out[name].is_a?(Array)
              out[name] = [out[name]]
            end
            out[name] << child.to_hash
          else
            out[name] = child.to_hash
          end
        end
        out
      end
    end
  end
end