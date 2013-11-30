module Saxerator
  module DSL
    def for_tag(*tags)
      for_tags(tags)
    end

    def for_tags(tags)
      raise ArgumentError.new('#for_tags requires an Array argument') unless tags.is_a? Array
      specify Latches::ForTags.new(tags.map(&:to_s))
    end

    def at_depth(depth)
      specify Latches::AtDepth.new(depth.to_i)
    end

    def within(tag)
      specify Latches::Within.new(tag.to_s)
    end

    def child_of(tag)
      specify Latches::ChildOf.new(tag.to_s)
    end

    def with_attribute(name, value = nil)
      specify Latches::WithAttributes.new({name.to_s => !!value ? value.to_s : nil })
    end

    def with_attributes(attrs)
      if attrs.is_a? Array
        attrs = Hash[attrs.map { |k| [k, nil]}]
      elsif attrs.is_a? Hash
        attrs = Hash[attrs.map{ |k, v| [k.to_s, v ? v.to_s : v]}]
      else
        raise ArgumentError.new("attributes should be a Hash or Array")
      end
      specify Latches::WithAttributes.new(attrs)
    end

    private
    def specify(predicate)
      DocumentFragment.new(@source, @config, @latches + [predicate])
    end
  end
end
