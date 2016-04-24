require 'hl7/message'
require 'hl7/segment'
require 'hl7/field'
require 'hl7/component'
require 'hl7/sub_component'

require 'hl7/parser/message'
require 'hl7/parser/segment'
require 'hl7/parser/field'
require 'hl7/parser/component'
require 'hl7/parser/sub_component'

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

    def parse
      parse_message(input)
    end

    def parse_message(input)
      segments = Parser::Message.new(
        input: input,
        escape: delimiters.escape
      ).parse.map { |s| parse_segment(s) }
      HL7::Message.new(segments: segments)
    end

    def parse_segment(input)
      fields = Parser::Segment.new(
        input: input,
        delimiter: delimiters.field,
        escape: delimiters.escape
      ).parse
      parsed = if fields[:type] == 'MSH'
                 msh_fields(fields[:content])
               else
                 fields[:content].map { |e| parse_field(e) }
               end
      HL7::Segment.new(type: fields[:type], fields: parsed)
    end

    def msh_fields(fields)
      fields[0..1] + fields[2..-1].map { |e| parse_field(e) }
    end

    def parse_field(input)
      components = Parser::Field.new(
        input: input,
        repetition_delimiter: delimiters.repetition,
        component_delimiter: delimiters.component,
        escape: delimiters.escape
      ).parse
      HL7::Field.new(components: components.map { |r| parse_repetition(r) })
    end

    def parse_repetition(input)
      input.map { |f| parse_component(f) }
    end

    def parse_component(input)
      sub_components = Parser::Component.new(
        input: input,
        delimiter: delimiters.sub_component,
        escape: delimiters.escape
      ).parse
      HL7::Component.new(
        sub_components: sub_components.map { |h| parse_sub_component(h) }
      )
    end

    def parse_sub_component(input)
      HL7::SubComponent.new(
        content: Parser::SubComponent.new(input: input).parse
      )
    end
  end
end
