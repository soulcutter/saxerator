module Saxerator
  class DocumentFragment
    include Enumerable
    include DSL

    def initialize(source, config = nil, latches = [])
      @source = source
      @latches = latches
      @config = config
    end

    def each(&block)
      reader = Parser::LatchedAccumulator.new(@config, @latches, block)
      parser = Nokogiri::XML::SAX::Parser.new(reader)

      # Always have to start at the beginning of a File
      @source.rewind if @source.respond_to?(:rewind)

      parser.parse(@source)
    end
  end
end