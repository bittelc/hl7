require 'parslet'

module HL7
  # TODO: doc
  # :nodoc:
  class Parser < Parslet::Parser
    attr_accessor :fd, :cd, :rd, :sd
    def initialize(options = {})
      @field_delimiter = options[:fd]
      @component_delimiter = options[:cd]
      @repetition_delimiter = options[:rd]
      @subcomponent_delimiter = options[:sd]
    end

    rule(:valid_delimiters) { str('|') | str('^') | str('&') | str('~') }
    rule(:segment_delimiter) { str("\r") }
    rule(:field_delimiter) do
      @field_delimiter.nil? ? valid_delimiters : str(@field_delimiter)
    end
    rule(:component_delimiter) do
      @component_delimiter.nil? ? valid_delimiters : str(@component_delimiter)
    end
    rule(:sub_component_delimiter) do
      if @subcomponent_delimiter.nil?
        valid_delimiters
      else
        str(@subcomponent_delimiter)
      end
    end
    rule(:escape) { str('\\') }
    rule(:repetition_delimiter) do
      @repetition_delimiter.nil? ? valid_delimiters : str(@repetition_delimiter)
    end
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
    rule(:sub_components) { (sub_component >> sub_component_delimiter.maybe).repeat(1) }
    rule(:component) { sub_components.repeat(1).as(:component) }
    rule(:components) { (component >> component_delimiter.maybe).repeat(1) }
    rule(:repetition) { components.repeat(1).as(:repetition) }
    rule(:repetitions) { (repetition >> repetition_delimiter.maybe).repeat(1) }
    rule(:field) { repetitions.repeat(1).as(:field) }
    rule(:fields) { (field >> field_delimiter.maybe).repeat(1) }
    rule(:segment_type) { match['[:alnum:]'].repeat(3, 3).as(:type) }
    rule(:segment) do
      (
        segment_type >>
        field_delimiter >>
        fields.repeat.as(:fields)
      ).as(:segment)
    end
    rule(:char_sets) do
      (
        field_delimiter.as(:field_delimiter) >>
        component_delimiter.as(:component_delimiter) >>
        repetition_delimiter.as(:repetition_delimiter) >>
        escape.as(:escape) >>
        sub_component_delimiter.as(:sub_component_delimiter) >>
        field_delimiter.as(:field_delimiter)
      )
    end
    rule(:msh_segment) do
      (
        str('MSH').as(:type) >>
        char_sets.as(:char_sets) >>
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
    root(:message)
  end
end
# Can call parser with
# irb> pp HL7::Parse.new.parse("MSH....")
