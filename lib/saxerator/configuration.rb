module Saxerator
  class Configuration
    attr_reader :output_type
    attr_writer :hash_key_generator

    def initialize
      @output_type = :hash
    end

    def output_type=(val)
      raise ArgumentError.new("Unknown output_type '#{val.inspect}'") unless Builder.valid?(val)
      @output_type = val
    end

    def hash_key_generator
      @hash_key_generator ||= lambda { |x| x.to_s }
    end

    def symbolize_keys!
      @hash_key_generator = lambda { |x| x.to_sym }
    end
  end
end