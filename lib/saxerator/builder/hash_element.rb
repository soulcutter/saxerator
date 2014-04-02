require 'saxerator/builder/array_element'

module Saxerator
  module Builder
    class HashElement < Hash
      attr_accessor :attributes
      attr_accessor :name

      def initialize(name, attributes)
        self.name = name
        self.attributes = attributes
      end

      def to_a
        array = ArrayElement.new
        array.name = name
        array.concat super
        array
      end

      def to_h; self end
    end
  end
end
