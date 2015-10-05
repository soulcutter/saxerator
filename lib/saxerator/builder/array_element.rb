require 'delegate'

module Saxerator
  module Builder
    class ArrayElement < DelegateClass(Array)
      attr_accessor :name

      def initialize(arr = [])
        super(arr)
      end

      def to_a; self end
    end
  end
end
