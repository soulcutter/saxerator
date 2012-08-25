module Saxerator
  module DSL
    def for_tag(tag)
      specify Parser::ForTagLatch.new(tag.to_s)
    end

    def at_depth(depth)
      specify Parser::AtDepthLatch.new(depth.to_i)
    end

    def within(tag)
      specify Parser::WithinLatch.new(tag.to_s)
    end

    def child_of(tag)
      specify Parser::ChildOfLatch.new(tag.to_s)
    end

    def with_attribute(name, value = nil)
      specify Parser::WithAttributeLatch.new(name.to_s, !!value ? value.to_s : nil)
    end

    private
    def specify(predicate)
      DocumentFragment.new(@source, @config, @latches + [predicate])
    end
  end
end