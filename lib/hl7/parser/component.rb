require 'hl7/component'

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
        sub_components = input.split(/(?<!#{escape})#{delimiter}/)
        HL7::Component.new(sub_components: sub_components)
      end
    end
  end
end
