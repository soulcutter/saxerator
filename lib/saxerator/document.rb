module Saxerator
  class Document
    include Enumerable

    def initialize(source, config = nil, latches = [])
      @source = source
      @latches = latches
      @config = config
    end

    def for_tag(tag)
      Document.new(@source, @config, @latches + [Parser::ElementNameLatch.new(tag.to_s)])
    end

    def each(&block)
      document = Parser::LatchedAccumulator.new(@config, @latches, block)
      parser = ::Nokogiri::XML::SAX::Parser.new document

      # Always have to start at the beginning of a File
      @source.rewind if(@source.is_a?(File))

      parser.parse(@source)
    end
  end
end