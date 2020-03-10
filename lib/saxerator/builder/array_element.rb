require 'delegate'

module Saxerator
  module Builder
    class ArrayElement < DelegateClass(Array)
      attr_accessor :name, :attributes

      def initialize(arr = [], name = nil, attributes = nil)
        @name = name
        @attributes = attributes
        super(arr)
      end

      def to_a; self end
    end
  end
end
