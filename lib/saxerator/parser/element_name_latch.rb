require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class ElementNameLatch < DocumentLatch
      def initialize(name)
        @name = name
      end

      def start_element name, _
        name == @name ? open : close
      end

      def end_element name
        close if name == @name
      end
    end
  end
end
