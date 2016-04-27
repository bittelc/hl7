require 'parslet'

module HL7
  # TODO: doc
  # :nodoc:
  class Parser < Parslet::Parser
    rule(:segment_delimiter) { str("\r") }
    rule(:field_delimiter) { str('|') }
    rule(:component_delimiter) { str('^') }
    rule(:sub_component_delimiter) { str('&') }
    rule(:escape) { str('\\') }
    rule(:repetition_delimiter) { str('~') }
    rule(:normal_character) do
      (
        segment_delimiter |
        field_delimiter |
        component_delimiter |
        sub_component_delimiter |
        escape |
        repetition_delimiter
      ).absent? >> any
    end
    rule(:sub_component) { normal_character.repeat(1).as(:sub_component) }
    rule(:sub_components) do
      (sub_component >> sub_component_delimiter.maybe).repeat(1)
    end
    rule(:component) { sub_components.repeat(1).as(:component) }
    rule(:components) { (component >> component_delimiter.maybe).repeat(1) }
    rule(:field) { components.repeat(1).as(:field) }
    rule(:fields) { (field >> field_delimiter.maybe).repeat(1) }
    rule(:segment_type) { match['[:alnum:]'].repeat(3, 3).as(:type) }
    rule(:segment) do
      (
        segment_type >>
        field_delimiter >>
        fields.repeat.as(:fields)
      ).as(:segment)
    end
    rule(:msh_segment) do
      (
        str('MSH').as(:type) >>
        field_delimiter >>
        component_delimiter >>
        repetition_delimiter >>
        escape >>
        sub_component_delimiter >>
        field_delimiter >>
        fields.repeat.as(:fields)
      ).as(:header)
    end
    rule(:message) do
      (
        msh_segment >>
        segment_delimiter >>
        segment.repeat.as(:segments)
      ).as(:message)
    end
  end
end
