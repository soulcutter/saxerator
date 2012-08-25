require 'saxerator/parser/document_latch'

module Saxerator
  module Parser
    class WithAttributeLatch < DocumentLatch
      def initialize(name, value)
        @attr_name = name
        @attr_value = value
      end

      def start_element _, attributes
        attributes = Hash[attributes]
        if attributes[@attr_name] && (@attr_value.nil? || attributes[@attr_name] == @attr_value)
          open
        else
          close
        end
      end

      def end_element _
        close
      end
    end
  end
end
