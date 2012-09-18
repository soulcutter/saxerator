module Saxerator
  class FullDocument
    include DSL

    def initialize(source, config)
      @source = source
      @config = config
      @latches = []
    end

    def all
      DocumentFragment.new(@source, @config, @latches).first
    end
  end
end