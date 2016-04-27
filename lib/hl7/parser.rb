require 'parslet'

module HL7
  # TODO: doc
  # :nodoc:
  class Parser < Parslet::Parser
    rule(:sub_component) { match['^&'].repeat(1).as(:sub_component) }
    rule(:sub_components) do
      (
        sub_component >>
        str('&').maybe
      ).repeat(1)
    end
    rule(:component) { match['^^'].repeat(1).as(:component) }
    rule(:components) do
      (
        component >>
        str('^').maybe
      ).repeat(1)
    end
    rule(:field) { match['^|'].repeat(1).as(:field) }
    rule(:fields) do
      (
        field >>
        str('|').maybe
      ).repeat(1)
    end
  end
end
