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
        document = LatchedAccumulator.new(@config, [ElementNameLatch.new(@tag)], block)
        parser = ::Nokogiri::XML::SAX::Parser.new document

        # Always have to start at the beginning of a File
        @source.rewind if(@source.is_a?(File))

        parser.parse(@source)
      end
    end
  end
end