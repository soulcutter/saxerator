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
      # Always have to start at the beginning of a File
      @source.rewind if @source.respond_to?(:rewind)

      reader = Parser::LatchedAccumulator.new(@config, @latches, block)
      @config.adapter.parse(@source, reader)
    end
  end
end
