require 'saxerator/builder/array_element'
require 'delegate'

module Saxerator
  module Builder
    class StringElement < DelegateClass(String)
      attr_accessor :attributes
      attr_accessor :name

      def initialize(str, name, attributes)
        @name = name
        @attributes = attributes
        super(str)
      end

      def to_a
        ArrayElement.new(self, name)
      end

      def is_a?(k); super(k) || k == String end

      def kind_of?(k); super(k) || k == String end
    end
  end
end
