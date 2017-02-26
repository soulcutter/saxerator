require 'forwardable'
require 'rexml/document'
require 'rexml/streamlistener'

module Saxerator
  module Adapters
    class Rexml
      extend Forwardable
      include REXML::StreamListener

      def self.parse(source, reader)
        handler = new(reader)
        REXML::Document.parse_stream(source, handler)
      end

      def initialize(reader)
        @reader = reader
        @ignore_namespaces = reader.ignore_namespaces?
      end

      def_delegator :@reader, :characters, :text
      def_delegator :@reader, :characters, :cdata

      def tag_start(name, attrs)
        name = strip_namespace(name) if @ignore_namespaces
        @reader.start_element(name, attrs)
      end

      def tag_end(name)
        name = strip_namespace(name) if @ignore_namespaces
        @reader.end_element(name)
      end

      private

      def strip_namespace(name)
        name.split(':').last
      end

    end
  end
end
