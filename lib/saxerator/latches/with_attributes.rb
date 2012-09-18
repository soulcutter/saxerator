require 'saxerator/latches/abstract_latch'

module Saxerator
  module Latches
    class WithAttributes < AbstractLatch
      def initialize(attrs)
        @attrs = attrs
      end

      def start_element _, attributes
        attributes = Hash[attributes]
        if @attrs.all? { |k, v| attributes[k] && (v.nil? || attributes[k] == v) }
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
