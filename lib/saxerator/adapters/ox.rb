require 'forwardable'
require 'ox'

module Saxerator
  module Adapters
    class Ox # < ::Ox::Sax
      extend Forwardable

      def self.parse(source, reader)
        handler = new(reader)
        ::Ox.sax_parse(handler, source)
      end

      attr_accessor :name
      attr_reader :attributes
      attr_reader :reader

      def initialize(reader)
        @reader = reader

        @attributes = {}
        @name = ''
      end

      def guard!
        reader.start_element(name, attributes.to_a) unless name.empty?
        reset!
      end

      def attr(name, value)
        attributes[name.to_s] = value
      end

      def start_element(name)
        guard!

        name = name.to_s
        name = strip_namespace(name) if reader.ignore_namespaces?
        self.name = name
      end

      def end_element(name)
        guard!

        name = name.to_s
        name = strip_namespace(name) if reader.ignore_namespaces?
        reader.end_element(name)
      end

      def text(str)
        guard!
        reader.characters(str)
      end

      alias cdata text

      private

      def reset!
        @attributes.clear
        @name = ''
      end

      def strip_namespace(name)
        name.split(':').last
      end
    end
  end
end
