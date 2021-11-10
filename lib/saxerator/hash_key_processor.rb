module Saxerator
  class HashKeyProcessor
    class DefultNormalizer
      def run(key)
        key.to_s
      end
    end

    class StripNormalizer < DefultNormalizer
      def initialize(*namespaces)
        @namespaces_regexp = if namespaces.any?
                               /(#{namespaces.join('|')}):/
                             else
                               /\w+:/
                             end
      end

      def run(key)
        super.gsub(@namespaces_regexp, '')
      end
    end

    attr_accessor :symbolize_keys

    def initialize
      @normalizer = DefultNormalizer.new
      @symbolize_keys = false
      @strip_namespaces = false
    end

    def generate(key)
      @symbolize_keys ? @normalizer.run(key).to_sym : @normalizer.run(key)
    end

    def strip_namespaces!(*namespaces)
      @normalizer = StripNormalizer.new(*namespaces)
    end
  end
end
