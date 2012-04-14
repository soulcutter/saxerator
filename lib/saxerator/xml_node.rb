module Saxerator
  class XmlNode
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

    def to_s
      string = StringWithAttributes.new(@children.join)
      string.attributes = @attributes
      string
    end

    def to_hash
      if @text
        to_s
      else
        out = HashWithAttributes.new
        out.attributes = @attributes

        @children.each do |child|
          name = child.name
          element = child.to_hash
          if out[name]
            if !out[name].is_a?(Array)
              out[name] = [out[name]]
            end
            out[name] << element
          else
            out[name] = element
          end
        end
        out
      end
    end
  end
end