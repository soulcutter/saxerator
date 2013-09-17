module Saxerator
  class Configuration
    attr_reader :output_type
    attr_writer :hash_key_generator

    def initialize
      @output_type = :hash
      @put_attributes_in_hash = false
    end

    def output_type=(val)
      raise ArgumentError.new("Unknown output_type '#{val.inspect}'") unless Builder.valid?(val)
      @output_type = val
      raise_error_if_using_put_attributes_in_hash_with_xml
    end

    def hash_key_generator
      @hash_key_generator ||= lambda { |x| x.to_s }
    end

    def symbolize_keys!
      @hash_key_generator = lambda { |x| x.to_sym }
    end
    
    def put_attributes_in_hash!
      @put_attributes_in_hash = true
      raise_error_if_using_put_attributes_in_hash_with_xml      
    end
    
    def put_attributes_in_hash?
      @put_attributes_in_hash
    end
    
    def raise_error_if_using_put_attributes_in_hash_with_xml
      if @output_type != :hash && @put_attributes_in_hash
        raise ArgumentError.new("put_attributes_in_hash! is only valid when using output_type = :hash (the default)'") 
      end
    end
  end
end