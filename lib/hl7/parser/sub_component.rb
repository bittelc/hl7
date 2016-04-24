module HL7
  class Parser
    class SubComponent
      attr_reader :input

      def initialize(input: '')
        @input = input
      end

      def parse
        input
      end
    end
  end
end
