require 'test_helper'
require 'hl7/segment'

class HL7SegmentTest < Minitest::Test
  def setup
    @klass = HL7::Segment
  end

  def test_stringifying_empty_segment
    segment = @klass.new(fields: [], type: 'ZZZ')
    assert_equal 'ZZZ', segment.to_s
  end

  def test_stringifying_full_segment
    type = 'ZAA'
    fields = %w(some segment fields)
    segment = @klass.new(type: type, fields: fields)
    assert_equal ([type] + fields).join('|'), segment.to_s
  end
end
