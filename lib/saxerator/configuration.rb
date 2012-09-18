module Saxerator
  class Configuration
    attr_accessor :output_type

    def initialize
      @output_type = :hash
    end

    def output_type=(val)
      raise ArgumentError("Unknown output_type '#{val.inspect}'") unless Builder.valid?(val)
      super
    end
  end
end