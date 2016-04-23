module HL7
  # Parser for ER7-encoded messages
  class Parser
    Delimiters = Struct.new(:field, :component, :repetition, :escape,
                            :sub_component)

    attr_reader :input, :delimiters

    def initialize(str)
      raise ArgumentError unless str.start_with? 'MSH'
      @input = str.freeze
      @delimiters = Delimiters.new(*input[3..7].split('')).freeze
    end
  end
end
