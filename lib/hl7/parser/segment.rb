module HL7
  class Parser
    class Segment
      attr_reader :input, :delimiter, :escape

      def initialize(input: '', delimiter: '|', escape: '\\')
        @input = input
        @delimiter = delimiter
        @escape = escape
      end

      def parse
        e = Regexp.escape escape
        d = Regexp.escape delimiter
        fields = input.split(/(?<!#{e})#{d}/)
        type = fields.shift
        fields.unshift(delimiter) if type == 'MSH'
        { type: type, content: fields }
      end
    end
  end
end
