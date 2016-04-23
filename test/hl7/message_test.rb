require 'english'
require 'test_helper'
require 'hl7/message'

class HL7MessageTest < Minitest::Test
  def setup
    @klass = HL7::Message
  end

  def test_empty
    skip
    assert_equal '', @klass.new.to_s
    assert @klass.new.empty?
  end

  def test_delimiter_default_is_newline
    skip
    assert_equal "\n", @klass.new.delimiter
    assert_equal '%', @klass.new(delimiter: '%').delimiter
  end

  def test_message_is_a_bag_of_segments
    skip
    assert @klass.new(segments: []).empty?
  end

  def test_type_comes_from_msh_segment
    skip
  end
end
