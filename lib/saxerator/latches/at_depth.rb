module Saxerator
  module Latches
    class AtDepth < Nokogiri::XML::SAX::Document
      def initialize(depth)
        @target_depth = depth
        @current_depth = -1
      end

      def start_element(_, __)
        @current_depth += 1
      end

      def end_element(_)
        @current_depth -= 1
      end

      def open?
        @current_depth == @target_depth
      end
    end
  end
end