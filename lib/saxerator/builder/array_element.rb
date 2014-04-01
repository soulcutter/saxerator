module Saxerator
  module Builder
    class ArrayElement < Array
      attr_accessor :name

      def to_ary; self end
      def to_a; self end
    end
  end
end
