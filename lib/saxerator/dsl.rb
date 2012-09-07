module Saxerator
  module DSL
    def for_tag(tag)
      for_tags([tag])
    end

    def for_tags(tags)
      raise ArgumentError.new('#for_tags requires an Array argument') unless tags.is_a? Array
      specify Parser::ForTagsLatch.new(tags.map(&:to_s))
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
      specify Parser::WithAttributesLatch.new({name.to_s => !!value ? value.to_s : nil })
    end

    def with_attributes(attrs)
      if attrs.is_a? Array
        attrs = Hash[attrs.map { |k| [k, nil]}]
      elsif attrs.is_a? Hash
        attrs = Hash[attrs.map{ |k, v| [k.to_s, v ? v.to_s : v]}]
      else
        raise ArgumentError.new("attributes should be a Hash or Array")
      end
      specify Parser::WithAttributesLatch.new(attrs)
    end

    private
    def specify(predicate)
      DocumentFragment.new(@source, @config, @latches + [predicate])
    end
  end
end