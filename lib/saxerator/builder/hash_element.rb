module Saxerator
  module Builder
    class HashElement < Hash
      attr_accessor :attributes
      attr_accessor :name

      def initialize(name, attributes)
        self.name = name
        self.attributes = attributes
      end
    end
  end
end