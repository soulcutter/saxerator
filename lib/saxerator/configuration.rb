module Saxerator
  class Configuration
    attr_reader :output_type, :hash_key_processor

    ADAPTER_TYPES = %i[ox nokogiri rexml oga].freeze

    def initialize
      @adapter = :rexml
      @output_type = :hash
      @put_attributes_in_hash = false
      @ignore_namespaces = false
      @hash_key_processor = Saxerator::HashKeyProcessor.new
    end

    def adapter=(name)
      unless ADAPTER_TYPES.include?(name)
        raise ArgumentError, "Unknown adapter '#{name.inspect}'"
      end
      @adapter = name
    end

    def adapter
      require "saxerator/adapters/#{@adapter}"
      Saxerator::Adapters.const_get(@adapter.to_s.capitalize, false)
    end

    def output_type=(val)
      raise ArgumentError, "Unknown output_type '#{val.inspect}'" unless Builder.valid?(val)
      @output_type = val
      raise_error_if_using_put_attributes_in_hash_with_xml
    end

    def output_type
      @_output_type ||= Builder.to_class(@output_type)
    end

    def symbolize_keys!
      @hash_key_processor.symbolize_keys = true
    end

    def strip_namespaces!(*namespaces)
      @hash_key_processor.strip_namespaces!(*namespaces)
    end

    def ignore_namespaces?
      @ignore_namespaces
    end

    def ignore_namespaces!
      @ignore_namespaces = true
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
        raise ArgumentError, "put_attributes_in_hash! is only valid \
                              when using output_type = :hash (the default)'"
      end
    end
  end
end
