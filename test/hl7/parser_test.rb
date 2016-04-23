require 'test_helper'
require 'hl7/parser'

class HL7ParserTest < Minitest::Test
  def setup
    @klass = HL7::Parser
  end

  def test_msh_is_first_segment
    skip
    good = 'MSH'
    bad = 'ZZZ'
    @klass.new good
    assert_raises(ArgumentError) { @klass.new bad }
  end

  def test_delimiter_detection
    skip
    defaults = 'MSH|^~\\&'
    d = @klass.new(defaults).delimiters
    assert_equal '|', d.field
    assert_equal '^', d.component
    assert_equal '~', d.repetition
    assert_equal '\\', d.escape
    assert_equal '&', d.sub_component
  end

  def test_unconventional_delimiter_detection
    skip
    message = 'MSHhjkl;'
    d = @klass.new(message).delimiters
    assert_equal 'h', d.field
    assert_equal 'j', d.component
    assert_equal 'k', d.repetition
    assert_equal 'l', d.escape
    assert_equal ';', d.sub_component
  end

  def test_stringification
    skip
  end
end
