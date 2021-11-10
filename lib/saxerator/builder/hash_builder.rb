module Saxerator
  module Builder
    class HashBuilder
      attr_reader :name

      def initialize(config, name, attributes)
        @config = config
        @hash_key_processor = config.hash_key_processor
        @name = @hash_key_processor.generate(name)
        @attributes = normalize_attributes(attributes)
        @children = []
      end

      def add_node(node)
        @children << node
      end

      def to_s
        StringElement.new(@children.join, @name, @attributes)
      end

      def to_hash
        hash = HashElement.new(@name, @attributes)

        @children.each do |child|
          name = child.name
          element = child.block_variable

          add_to_hash_element(hash, name, element)
        end

        if @config.put_attributes_in_hash?
          @attributes.each do |attribute|
            attribute.each_slice(2) do |name, element|
              add_to_hash_element(hash, name, element)
            end
          end
        end

        hash
      end

      def to_array
        arr = @children.map do |child|
          if child.kind_of?(String)
            StringElement.new(child)
          else
            child.block_variable
          end
        end
        ArrayElement.new(arr, @name, @attributes)
      end

      def add_to_hash_element(hash, name, element)
        name = generate_key(name)
        if hash.key? name
          unless hash[name].is_a?(ArrayElement)
            hash[name] = ArrayElement.new([hash[name]], name)
          end
          hash[name] << element
        else
          hash[name] = element
        end
      end

      def block_variable
        return to_hash unless @children.any? { |c| c.kind_of?(String) }
        return to_s if @children.all? { |c| c.kind_of?(String) }

        to_array
      end

      def normalize_attributes(attributes)
        Hash[attributes.map { |key, value| [generate_key(key), value] }]
      end

      def generate_key(name)
        @hash_key_processor.generate(name)
      end
    end
  end
end
