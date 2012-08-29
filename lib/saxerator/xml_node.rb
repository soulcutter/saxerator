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
      string.name = @name
      string
    end

    def to_hash
      hash = HashWithAttributes.new

      @children.each do |child|
        name = child.name
        element = child.block_variable

        if hash[name]
          if !hash[name].is_a?(Array)
            hash[name] = [hash[name]]
          end
          hash[name] << element
        else
          hash[name] = element
        end
      end

      hash
    end

    def block_variable
      variable = @text ? to_s : to_hash
      variable.attributes = @attributes
      variable.name = @name
      variable
    end
  end
end