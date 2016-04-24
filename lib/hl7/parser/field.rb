module HL7
  class Parser
    class Field
      attr_reader :input, :component, :repetition, :escape
      def initialize(input: '',
                     component_delimiter: '^',
                     repetition_delimiter: '~',
                     escape: '\\')
        @input = input
        @component = Regexp.escape component_delimiter
        @repetition = Regexp.escape repetition_delimiter
        @escape = Regexp.escape escape
      end

      def parse
        repetitions = input.split(/(?<!#{escape})#{repetition}/)
        repetitions.map do |e|
          e.split(/(?<!#{escape})#{component}/)
        end
      end
    end
  end
end
