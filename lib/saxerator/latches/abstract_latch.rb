module Saxerator
  module Latches
    class AbstractLatch < Nokogiri::XML::SAX::Document
      def open
        @open = true
      end

      def close
        @open = false
      end

      def open?
        @open
      end
    end
  end
end
