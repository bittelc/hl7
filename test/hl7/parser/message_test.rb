require 'test_helper'
require 'hl7/parser/message'

class HL7ParserMessageTest < Minitest::Test
  def setup
    @klass = HL7::Parser::Message
  end

  def test_normal
    message = "1\n2\n3\n4"
    parsed = @klass.new(input: message).parse
    assert_equal 4, parsed.length
  end

  def test_escaped
    message = "1\n\\\n2\n3\n4"
    parsed = @klass.new(input: message, escape: '\\').parse
    assert_equal 4, parsed.length
  end

  def test_alternative_escaped
    message = "1\\\n2a\nba\n\n3\n4"
    parsed = @klass.new(input: message, escape: 'a').parse
    assert_equal 4, parsed.length
  end
end
