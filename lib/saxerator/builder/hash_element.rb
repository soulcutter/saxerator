require 'saxerator/builder/array_element'
require 'delegate'

module Saxerator
  module Builder
    class HashElement < DelegateClass(Hash)
      attr_accessor :attributes
      attr_accessor :name

      def initialize(name = nil, attributes = nil)
        @name = name
        @attributes = attributes
        super({})
      end

      def to_a
        ArrayElement.new(super, name)
      end

      def to_h; self end

      def is_a?(k); super(k) || k == Hash end

      def kind_of?(k); super(k) || k == Hash end
    end
  end
end
