module HL7
  class Parser
    class Component
      attr_reader :input, :delimiter, :escape

      def initialize(input: '', delimiter: '&', escape: '\\')
        @input = input
        @delimiter = Regexp.escape delimiter
        @escape = Regexp.escape escape
      end

      def parse
        input.split(/(?<!#{escape})#{delimiter}/)
      end
    end
  end
end
