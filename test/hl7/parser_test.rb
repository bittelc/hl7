require 'test_helper'
require 'hl7/parser'

# rubocop:disable ClassLength
class HL7ParserTest < Minitest::Test
  def setup
    @klass = HL7::Parser
    @obj = @klass.new
  end

  # rubocop:disable MethodLength
  def self.equality_test_for(
    input: '',
    expectation: nil,
    parse_method: nil,
    skipped: false
  )
    @counter ||= 0
    @counter += 1
    define_method("test_#{@counter}_#{parse_method}") do
      skip if skipped
      assert_equal expectation, @obj.send(parse_method).parse(input)
    end
  end
  # rubocop:enable MethodLength

  [
    {
      input: 'foo',
      expectation: { sub_component: 'foo' },
      parse_method: :sub_component
    },
    {
      input: 'foo&bar&',
      expectation: [
        { sub_component: 'foo' },
        { sub_component: 'bar' }
      ],
      parse_method: :sub_components
    },
    {
      skipped: true,
      input: 'foo&bar',
      expectation: {
        component: [
          { sub_component: 'foo' },
          { sub_component: 'bar' }
        ]
      },
      parse_method: :component
    },
    {
      skipped: true,
      input: 'foo^bar',
      expectation: [
        { component: { sub_component: 'foo' } },
        { component: { sub_component: 'bar' } }
      ],
      parse_method: :components
    },
    {
      skipped: true,
      input: 'foo^bar&baz&^bing',
      expectation: {
        field: [
          { component: { sub_component: 'foo' } },
          {
            component: [
              { sub_component: 'bar' },
              { sub_component: 'baz' }
            ]
          },
          { component: { sub_component: 'bing' } }
        ]
      },
      parse_method: :field
    },
    {
      skipped: true,
      input: 'spam|eggs',
      expectation: [
        { field: { component: { sub_component: 'spam' } } },
        { field: { component: { sub_component: 'eggs' } } }
      ],
      parse_method: :fields
    }
  ].each do |h|
    equality_test_for(h)
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

  # rubocop:disable MethodLength
  def test_accession
    skip
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
