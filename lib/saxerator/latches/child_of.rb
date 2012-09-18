module Saxerator
  module Latches
    class ChildOf < Nokogiri::XML::SAX::Document
      def initialize(name)
        @name = name
        @depths = []
      end

      def start_element name, _
        if depth_within_element > 0
          increment_depth(1)
        end
        if @name == name
          @depths.push 1
        end
      end

      def end_element _
        if depth_within_element > 0
          increment_depth(-1)
          @depths.pop if @depths.last == 0
        end
      end

      def open?
        depth_within_element == 2
      end

      def increment_depth(amount)
        @depths.map! { |depth| depth + amount }
      end

      def depth_within_element
        @depths.size > 0 ? @depths.last : 0
      end
    end
  end
end
