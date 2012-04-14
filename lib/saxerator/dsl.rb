module Saxerator
  module DSL
    def for_tag(tag)
      DocumentFragment.new(@source, @config, @latches + [Parser::ElementNameLatch.new(tag.to_s)])
    end

    def at_depth(depth)
      DocumentFragment.new(@source, @config, @latches + [Parser::DepthLatch.new(depth.to_i)])
    end

    def within(tag)
      DocumentFragment.new(@source, @config, @latches + [Parser::WithinElementLatch.new(tag.to_s)])
    end
  end
end