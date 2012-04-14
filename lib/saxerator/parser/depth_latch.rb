require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class DepthLatch < DocumentLatch
      def initialize(depth)
        @depth = depth
        @actual_depth = 0
      end

      def start_element(_, __)
        @actual_depth += 1
        if @actual_depth == @depth
          open
        end
      end

      def end_element(_)
        @actual_depth -= 1
      end
    end
  end
end