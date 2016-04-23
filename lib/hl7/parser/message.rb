require 'hl7/message'

module HL7
  class Parser
    class Message
      attr_reader :input, :delimiter, :escape

      def initialize(input: '', escape: '\\')
        @input = input
        @delimiter = Regexp.escape "\n"
        @escape = Regexp.escape escape
      end

      def parse
        segments = input
          .split(/(?<!#{escape})#{delimiter}/)
          # TODO: strip escapes
          # .map { |e| e.gsub(/(?<!#{escape})#{escape}/, '') }
        HL7::Message.new(segments: segments)
      end
    end
  end
end
