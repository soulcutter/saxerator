module Saxerator
  module Attributes
    attr_accessor :attributes

    def attributes
      @attributes ||= {}
    end
  end
end