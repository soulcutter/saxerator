require 'forwardable'
require 'nokogiri'

module Saxerator
  module Adapters
    class Nokogiri < ::Nokogiri::XML::SAX::Document
      extend Forwardable

      def self.parse(source, reader)
        parser = ::Nokogiri::XML::SAX::Parser.new(new reader)
        parser.parse(source)
      end

      def initialize(reader)
        @reader = reader
      end

      def_delegators :@reader, :start_element, :end_element, :characters
      def_delegator :@reader, :characters, :cdata_block

      def start_element_namespace(name, attrs = [], prefix = nil, uri = nil, ns = [])
        super unless @ignore_namespaces
        start_element(name, strip_namespace(attrs))
      end

      def end_element_namespace(name, prefix = nil, uri = nil)
        super unless @ignore_namespaces
        end_element(name)
      end

      private

      def strip_namespace(attrs)
        attrs.map { |attr| [attr.localname, attr.value] }
      end
    end
  end
end
