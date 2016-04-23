require 'test_helper'
require 'hl7/parser/sub_component'

class HL7ParserValueTest < Minitest::Test
  def setup
    @klass = HL7::Parser::SubComponent
  end

  def test_this_is_just_a_string_value_object
    v = '\\my^value%with&many~meta|characters'
    obj = @klass.new(input: v).parse
    assert_equal v, obj.content
  end
end
