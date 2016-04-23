require 'test_helper'
require 'hl7/parser/component'

class HL7ParserComponentTest < Minitest::Test
  def setup
    @klass = HL7::Parser::Component
  end

  def test_normal
    component = '1&2&3&4'
    parsed = @klass.new(input: component, delimiter: '&').parse
    assert_equal 4, parsed.length
  end

  def test_other_delimiter
    component = '1a2a3a4'
    parsed = @klass.new(input: component, delimiter: 'a').parse
    assert_equal 4, parsed.length
  end

  def test_escaped
    component = '1\\&a&2&3&4'
    parsed = @klass.new(input: component, delimiter: '&', escape: '\\').parse
    assert_equal 4, parsed.length
  end
end
