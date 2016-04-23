require 'hl7/segment'

module HL7
  class Parser
    class Segment
      attr_reader :input, :delimiter, :escape

      def initialize(input: '', delimiter: '|', escape: '\\')
        @input = input
        @delimiter = Regexp.escape delimiter
        @escape = Regexp.escape escape
      end

      def parse
        fields = input.split(/(?<!#{escape})#{delimiter}/)
        type = fields.shift
        fields.unshift(delimiter) if type == 'MSH'
        HL7::Segment.new(type: type, fields: fields)
      end
    end
  end
end
