require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class ChildOfLatch < DocumentLatch
      def initialize(name)
        @name = name
        @depths = []
        @depth_within_element = 0
      end

      def start_element name, _
        if depth_within_element > 0
          increment_depth(1)
          resolve_open_status
        end
        if @name == name
          @depths.push 1
        end
      end

      def end_element _
        if depth_within_element > 0
          increment_depth(-1)
          @depths.pop if @depths.last == 0
          resolve_open_status
        end
      end

      def increment_depth(amount)
        @depths.map! { |depth| depth + amount }
      end

      def depth_within_element
        @depths.size > 0 ? @depths.last : 0
      end

      def resolve_open_status
        if depth_within_element == 2
          open
        else
          close
        end
      end
    end
  end
end
