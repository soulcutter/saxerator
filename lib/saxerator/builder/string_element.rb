module Saxerator
  module Builder
    class StringElement < String
      attr_accessor :attributes
      attr_accessor :name

      def initialize(str, name, attributes)
        self.name = name
        self.attributes = attributes
        super(str)
      end
    end
  end
end