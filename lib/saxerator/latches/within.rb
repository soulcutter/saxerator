module Saxerator
  module Latches
    class Within < Nokogiri::XML::SAX::Document
      def initialize(name)
        @name = name
        @depth_within_element = 0
      end

      def start_element name, _
        if name == @name || @depth_within_element > 0
          @depth_within_element += 1
        end
      end

      def end_element _
        if @depth_within_element > 0
          @depth_within_element -= 1
        end
      end

      def open?
        @depth_within_element > 1
      end
    end
  end
end