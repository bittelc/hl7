require 'test_helper'
require 'hl7/parser'

class HL7ParserTest < Minitest::Test
  def setup
    @klass = HL7::Parser
  end

  def test_msh_is_first_segment
    good = 'MSH'
    bad = 'ZZZ'
    @klass.new good
    assert_raises(ArgumentError) { @klass.new bad }
  end

  def test_delimiter_detection
    defaults = 'MSH|^~\\&'
    d = @klass.new(defaults).delimiters
    assert_equal '|', d.field
    assert_equal '^', d.component
    assert_equal '~', d.repetition
    assert_equal '\\', d.escape
    assert_equal '&', d.sub_component
  end

  def test_unconventional_delimiter_detection
    message = 'MSHhjkl;'
    d = @klass.new(message).delimiters
    assert_equal 'h', d.field
    assert_equal 'j', d.component
    assert_equal 'k', d.repetition
    assert_equal 'l', d.escape
    assert_equal ';', d.sub_component
  end

  # rubocop:disable MethodLength
  def test_accession
    message = <<HL7.freeze
MSH|^~\\&|RADIS1||DMCRES||19940502161633||ORU|19940502161633|D|2.2|964||AL|AL
PID|||N00803||RADIOLOGY^INPATIENT^SIX||19520606|F||A||||||||003555
PV1||I|N77^7714^01|||||||OB
OBR|1|003555.0015.001^DMCRES|0000000566^RADIS1|37953^CT CHEST^L|||199405021545|||||||||||||0000763||||CT|P||||||R/O TUMOR|202300^BAKER^MARK^E|||01^LOCHLEAR, JUDY
OBX||TX|FIND^FINDINGS^L|1|This is a test on 05/02/94.
OBX||TX|FIND^FINDINGS^L|2|This is a test for the CRR.
OBX||TX|FIND^FINDINGS^L|3|This is a test result to generate multiple obr's to check the cost
OBX||TX|FIND^FINDINGS^L|4|display for multiple exams.
OBX||TX|FIND^FINDINGS^L|5|APPROVING MD:
OBR|2|^DMCRES|0000000567^RADIS1|37956^CT ABDOMEN^L|||199405021550|||||||||||||0000763|||||P||||||R/O TUMOR|202300^BAKER^MARK^E|||01^LOCHLEAR, JUDY
OBR|3|^DMCRES|0000000568^RADIS1|37881^CT PELVIS (LIMITED)^L|||199405021551|||||||||||||0000763|||||P||||||R/O TUMOR|202300^BAKER^MARK^E|||01^LOCHLEAR, JUDY
HL7
    parsed = @klass.new(message).parse
    assert_equal '|', parsed
      .segments[0]
      .fields[0]
    assert_equal '^~\\&', parsed
      .segments[0]
      .fields[1]
    assert_equal '7714', parsed
      .segments[2]
      .fields[2]
      .components[0][1]
      .sub_components[0]
      .content
    assert_equal '19940502161633', parsed
      .segments[0]
      .fields[6]
      .components[0][0]
      .sub_components[0]
      .content
  end
end
