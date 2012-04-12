require 'nokogiri'

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
        document = Document.new(@config, @tag, block)
        parser = ::Nokogiri::XML::SAX::Parser.new document

        # Always have to start at the beginning of a File
        @source.rewind if(@source.is_a?(File))

        parser.parse(@source)
      end

      class Document < ::Nokogiri::XML::SAX::Document
        attr_accessor :stack

        def initialize(config, tag, block)
          @config = config
          @tag = tag
          @stack = []
          @block = block
        end

        def start_element(name, attrs = [])
          if stack.size > 0 || name == @tag
            stack.push XmlNode.new(@config, name, Hash[*attrs.flatten])
          end
        end

        def end_element(name)
          if stack.size > 1
            last = stack.pop
            stack.last.add_node last
          elsif stack.size == 1
            @block.call(stack.pop.to_hash)
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