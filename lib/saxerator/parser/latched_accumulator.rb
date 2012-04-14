module Saxerator
  module Parser
    class LatchedAccumulator < ::Nokogiri::XML::SAX::Document
      def initialize(config, latches, block)
        @latches = latches
        block_and_reset = Proc.new do |x|
          block.call(x)
          reset_latches
        end
        @accumulator = Accumulator.new(config, block_and_reset)
      end

      def reset_latches
        @latches.each(&:reset)
      end

      def check_latches_and_passthrough(method, *args)
        @latches.each { |latch| latch.send(method, *args) }
        if @latches.all?(&:open?)
          @accumulator.send(method, *args)
        else
          reset_latches
        end
      end

      def xmldecl version, encoding, standalone
        check_latches_and_passthrough(:xmldecl, version, encoding, standalone)
      end

      def start_document
        check_latches_and_passthrough(:start_document)
      end

      def end_document
        check_latches_and_passthrough(:end_document)
      end

      def start_element name, attrs = []
        check_latches_and_passthrough(:start_element, name, attrs)
      end

      def end_element name
        check_latches_and_passthrough(:end_element, name)
      end

      def start_element_namespace name, attrs = [], prefix = nil, uri = nil, ns = []
        check_latches_and_passthrough(:start_element_namespace, name, attrs, prefix, uri, ns)
      end

      def end_element_namespace name, prefix = nil, uri = nil
        check_latches_and_passthrough(:end_element_namespace, name, prefix, uri)
      end

      def characters string
        check_latches_and_passthrough(:characters, string)
      end

      def comment string
        check_latches_and_passthrough(:comment, string)
      end

      def warning string
        check_latches_and_passthrough(:warning, string)
      end

      def error string
        check_latches_and_passthrough(:error, string)
      end

      def cdata_block string
        check_latches_and_passthrough(:cdata_block, string)
      end
    end
  end
end
