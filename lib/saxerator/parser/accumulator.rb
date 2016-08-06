module Saxerator
  module Parser
    class Accumulator < ::Saxerator::SaxHandler
      def initialize(config, block)
        @stack = []
        @config = config
        @block = block
      end

      def start_element(name, attrs = [])
        @stack.push @config.output_type.new(@config, name, Hash[attrs])
      end

      def end_element(_)
        if @stack.size > 1
          last = @stack.pop
          @stack.last.add_node last
        else
          @block.call(@stack.pop.block_variable)
        end
      end

      def characters(string)
        @stack.last.add_node(string) unless string.strip.length == 0
      end

      def accumulating?
        @stack.size > 0
      end
    end
  end
end
