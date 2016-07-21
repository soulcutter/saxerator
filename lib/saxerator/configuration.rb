module Saxerator
  class Configuration
    attr_reader :output_type
    attr_writer :hash_key_generator

    ALLOWED_OUTPUT_TYPES = {
      nokogiri: [:hash, :xml],
      ox: [:hash]
    }.freeze

    def initialize
      @adapter = :nokogiri
      @output_type = :hash
      @put_attributes_in_hash = false
      @ignore_namespaces = false
    end

    def adapter=(name)
      @adapter = name
    end

    def adapter
      require "saxerator/adapters/#{@adapter}"
      Saxerator::Adapters.const_get(@adapter.to_s.capitalize, false)
    end

    def output_type=(val)
      raise_exeption("Unknown output_type '#{val.inspect}'") unless Builder.valid?(val)
      unless ALLOWED_OUTPUT_TYPES[@adapter].include?(val)
        raise_exeption("Adapter '#{adapter.inspect}' not allow to use output_type '#{val.inspect}'")
      end

      @output_type = val
      raise_error_if_using_put_attributes_in_hash_with_xml
    end

    def generate_key_for(val)
      hash_key_generator.call val
    end

    def hash_key_normalizer
      @hash_key_normalizer ||= lambda { |x| x.to_s }
    end

    def hash_key_generator
      @hash_key_generator || hash_key_normalizer
    end

    def symbolize_keys!
      @hash_key_generator = lambda { |x| hash_key_normalizer.call(x).to_sym }
    end

    def strip_namespaces!(*namespaces)
      if namespaces.any?
        matching_group = namespaces.join('|')
        @hash_key_normalizer = lambda { |x| x.to_s.gsub(/(#{matching_group}):/, '') }
      else
        @hash_key_normalizer = lambda { |x| x.to_s.gsub(/\w+:/, '') }
      end
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
        raise_exeption("put_attributes_in_hash! is only valid when using output_type = :hash (the default)'")
      end
    end

    private

    def raise_exeption(text)
      raise ArgumentError, text
    end
  end
end
