module Saxerator
  class HashWithAttributes < Hash
    attr_accessor :attributes
    attr_accessor :name
  end
end