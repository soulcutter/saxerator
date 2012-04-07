require 'nokogiri'
require 'fiber'

module Saxerator
  module Parser
    class Nokogiri
      include Enumerable

      def initialize(config, source, tag)
        @config = config
        @source = source
        @tag = tag
      end

      def each(&block)
        begin
          fiber = Fiber.new do
            document = Document.new(@config, @tag)
            parser = ::Nokogiri::XML::SAX::Parser.new document
            parser.parse(@source)
          end
          while fiber.alive? do
            result = fiber.resume
            yield(result) unless result.nil?
          end
        rescue FiberError
        end
      end

      class Document < ::Nokogiri::XML::SAX::Document
        attr_accessor :parser

        def initialize(config, tag)
          @config = config
          @tag = tag
        end

        def stack
          @stack ||= []
        end

        def start_element(name, attrs = [])
          if stack.size > 0 || name == @tag
            stack.push Saxerator::XmlNode.new(parser, name, Hash[*attrs.flatten])
          end
        end

        def end_element(name)
          if stack.size > 1
            last = stack.pop
            stack.last.add_node last
          elsif stack.size == 1
            Fiber.yield(stack.pop.to_hash)
          end
        end

        def characters(string)
          stack.last.add_node(string) unless string.strip.length == 0 || stack.empty?
        end

        alias cdata_block characters

      end
    end
  end
end