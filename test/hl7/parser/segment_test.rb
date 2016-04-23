require 'test_helper'
require 'hl7/parser/segment'

class HL7ParserSegment < Minitest::Test
  def setup
    @klass = HL7::Parser::Segment
  end

  def test_normal_parsing
    normal = 'ZZZ|1|2|3|4|5'
    parsed = @klass.new(input: normal, delimiter: '|').parse
    assert_equal 5, parsed.length
    assert_equal 'ZZZ', parsed.type
  end

  def test_msh_parsing
    msh = 'MSHabcdea1a2a3a4a5'
    parsed = @klass.new(input: msh, delimiter: 'a').parse
    assert_equal 7, parsed.length
    assert_equal 'MSH', parsed.type
  end

  def test_escaped_characters
    escaped = 'ZZZ|1|2|3|4|\\|\\||6'
    parsed = @klass.new(input: escaped, delimiter: '|', escape: '\\').parse
    assert_equal 6, parsed.length
    assert_equal 'ZZZ', parsed.type
  end
end
