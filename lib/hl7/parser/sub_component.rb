require 'hl7/sub_component'

module HL7
  class Parser
    class SubComponent
      attr_reader :input

      def initialize(input: '')
        @input = input
      end

      def parse
        HL7::SubComponent.new(content: input)
      end
    end
  end
end
