require 'forwardable'
require 'oga'

module Saxerator
  module Adapters
    class Oga
      extend Forwardable

      def self.parse(source, reader)
        parser = ::Oga::XML::SaxParser.new(new(reader), source)
        parser.parse
      end

      def initialize(reader)
        @reader = reader
        @ignore_namespaces = reader.ignore_namespaces?
      end

      def_delegator :@reader, :characters, :on_text
      def_delegator :@reader, :characters, :on_cdata

      def on_element(namespace, name, attrs = {})
        name = "#{namespace}:#{name}" if namespace && !@ignore_namespaces
        attrs = @ignore_namespaces ? strip_namespace(attrs) : attrs.to_a
        @reader.start_element(name, attrs)
      end

      def after_element(namespace, name)
        name = "#{namespace}:#{name}" if namespace && !@ignore_namespaces
        @reader.end_element(name)
      end

      private

      def strip_namespace(attrs)
        attrs.map { |k, v| [k.gsub(NAMESPACE_MATCHER, ''), v] }
      end

      NAMESPACE_MATCHER = /\A.+:/.freeze
    end
  end
end
