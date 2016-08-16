module Saxerator
  module Latches
    class Within < ::Saxerator::SaxHandler
      def initialize(name)
        @name = name
        @depth_within_element = 0
      end

      def start_element(name, _)
        @depth_within_element += 1 if name == @name || @depth_within_element > 0
      end

      def end_element(_)
        @depth_within_element -= 1 if @depth_within_element > 0
      end

      def open?
        @depth_within_element > 1
      end
    end
  end
end
