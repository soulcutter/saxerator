require 'saxerator/builder/array_element'
require 'delegate'

module Saxerator
  module Builder
    class HashElement < DelegateClass(Hash)
      attr_accessor :attributes
      attr_accessor :name

      def initialize(name = nil, attributes = nil)
        self.name = name
        self.attributes = attributes
        super({})
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
