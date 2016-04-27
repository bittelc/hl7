require 'parslet'

module HL7
  # TODO: doc
  # :nodoc:
  class Parser < Parslet::Parser
    rule(:sub_component) { match['^^&|\r'].repeat(1).as(:sub_component) }
    rule(:sub_components) do
      (
        sub_component >>
        str('&').maybe
      ).repeat(1)
    end
    rule(:component) { sub_components.repeat(1).as(:component) }
    rule(:components) do
      (
        component >>
        str('^').maybe
      ).repeat(1)
    end
    rule(:field) { components.repeat(1).as(:field) }
    rule(:fields) do
      (
        field >>
        str('|').maybe
      ).repeat(1)
    end
    rule(:segment) do
      (
        match['[:alnum:]'].repeat(3, 3).as(:type) >>
        str('|') >>
        fields.repeat(1).as(:fields)
      ).as(:segment)
    end
  end
end
