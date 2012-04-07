module Saxerator
  class StringWithAttributes < String
    attr_accessor :attributes

    def attribrutes
      @attributes ||= {}
    end
  end
end