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
    end
  end
end
