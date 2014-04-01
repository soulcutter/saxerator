require 'saxerator/builder/hash_element'

module Saxerator
  module Builder
    class EmptyElement < HashElement
      def nil?; true end
      def !; true end

      def to_s
        StringElement.new('', name, attributes)
      end

      def to_h
        HashElement.new(name, attributes)
      end

      def to_a
        array = ArrayElement.new
        array.name = name
        array
      end
    end
  end
end
