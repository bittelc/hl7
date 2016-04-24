require 'test_helper'
require 'hl7/parser/field'

class HL7ParserFieldTest < Minitest::Test
  def setup
    @klass = HL7::Parser::Field
  end

  def test_normal
    field = '1^2^3^4'
    parsed = @klass.new(input: field, component_delimiter: '^').parse
    assert_equal 4, parsed[0].length
  end

  def test_other_delimiters
    field = '1^a2a3a4'
    parsed = @klass.new(input: field, component_delimiter: 'a').parse
    assert_equal 4, parsed[0].length
  end

  def test_repetition
    field = '1^2^3^4~5^6^7'
    parsed = @klass.new(input: field,
                        component_delimiter: '^',
                        repetition_delimiter: '~').parse
    assert_equal 3, parsed[1].length
    assert_equal 3, parsed.fetch(1).length
  end

  def test_escaped
    field = '1^2^3\\^\\^\\^^\\~4~5^6^7'
    parsed = @klass.new(input: field,
                        component_delimiter: '^',
                        repetition_delimiter: '~',
                        escape: '\\').parse
    assert_equal 3, parsed[1].length
    assert_equal 3, parsed.fetch(1).length
  end
end
