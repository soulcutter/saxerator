module Saxerator
  class Configuration
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def for_tag(tag)
      Saxerator::Parser::Nokogiri.new(self, source, tag.to_s)
    end
  end
end