module Saxerator
  class Configuration
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def for_tag(tag)
      tag = tag.to_s
      Saxerator::Parser::Nokogiri.new(self, source, tag)
    end
  end
end