module Saxerator
  module Parser
    class DocumentLatch < ::Nokogiri::XML::SAX::Document
      def open
        @open = true
      end

      def close
        @open = false
      end

      def open?
        @open
      end

      def reset
        close
      end
    end
  end
end
