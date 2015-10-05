require 'saxerator/builder/array_element'
require 'delegate'

module Saxerator
  module Builder
    class StringElement < DelegateClass(String)
      attr_accessor :attributes
      attr_accessor :name

      def initialize(str, name, attributes)
        self.name = name
        self.attributes = attributes
        super(str)
      end

      def to_a
        array = ArrayElement.new
        array << self
        array.name = name
        array
      end
    end
  end
end
