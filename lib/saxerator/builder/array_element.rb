require 'delegate'

module Saxerator
  module Builder
    class ArrayElement < DelegateClass(Array)
      attr_accessor :name

      def initialize(arr = [], name = nil)
        @name = name
        super(arr)
      end

      def to_a; self end

      def is_a?(k); super(k) || k == Array end

      def kind_of?(k); super(k) || k == Array end
    end
  end
end
