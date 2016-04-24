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
        input.split(/(?<!#{escape})#{delimiter}/)
        # TODO: strip escapes
        # .map { |e| e.gsub(/(?<!#{escape})#{escape}/, '') }
      end
    end
  end
end
