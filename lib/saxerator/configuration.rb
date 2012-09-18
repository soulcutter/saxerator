module Saxerator
  class Configuration
    attr_reader :output_type

    def initialize
      @output_type = :hash
    end

    def output_type=(val)
      raise ArgumentError("Unknown output_type '#{val.inspect}'") unless Builder.valid?(val)
      @output_type = val
    end
  end
end