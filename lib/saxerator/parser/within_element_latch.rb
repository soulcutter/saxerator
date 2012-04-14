module Saxerator
  module Parser
    class WithinElementLatch < DocumentLatch
      def initialize(name)
        @name = name
        @inner_depth = 0
      end

      def start_element name, _
        if @inner_depth == 0
          if name == @name
            @inner_depth += 1
          end
        else
          open if @inner_depth == 1
          @inner_depth += 1
        end
      end

      def end_element _
        if @inner_depth > 0
          @inner_depth -= 1
          close if @inner_depth == 0
        end
      end

      def reset; end
    end
  end
end