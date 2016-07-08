module Saxerator
  module Latches
    class AbstractLatch < ::Saxerator::SaxHandler
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
