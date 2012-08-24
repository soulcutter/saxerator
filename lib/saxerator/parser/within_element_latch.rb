require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class WithinElementLatch < DocumentLatch
      def initialize(name)
        @name = name
        @depth_within_element = 0
      end

      def start_element name, _
        if name == @name || @depth_within_element > 0
          @depth_within_element += 1
          open if @depth_within_element == 2
        end
      end

      def end_element _
        if @depth_within_element > 0
          @depth_within_element -= 1
          close if @depth_within_element == 1
        end
      end
    end
  end
end