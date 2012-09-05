require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class ForTagsLatch < DocumentLatch
      def initialize(names)
        @names = names
      end

      def start_element name, _
        @names.include?(name) ? open : close
      end

      def end_element name
        close if @names.include?(name)
      end
    end
  end
end
