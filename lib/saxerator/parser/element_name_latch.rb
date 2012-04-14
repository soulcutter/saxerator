module Saxerator
  module Parser
    class ElementNameLatch < DocumentLatch
      def initialize(name)
        @name = name
      end

      def start_element(name, _)
        if name == @name
          open
        end
      end
    end
  end
end
