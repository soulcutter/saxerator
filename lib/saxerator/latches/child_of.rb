module Saxerator
  module Latches
    class ChildOf < ::Saxerator::SaxHandler
      def initialize(name)
        @name = name
        @depths = []
      end

      def start_element(name, _)
        increment_depth(1) if depth_within_element > 0
        @depths.push 1 if @name == name
      end

      def end_element(_)
        return unless depth_within_element > 0
        increment_depth(-1)
        @depths.pop if @depths[-1] == 0
      end

      def open?
        depth_within_element == 2
      end

      def increment_depth(amount)
        @depths.map! { |depth| depth + amount }
      end

      def depth_within_element
        !@depths.empty? ? @depths[-1] : 0
      end
    end
  end
end
