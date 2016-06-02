require 'test_helper'
require 'hl7/parser'

class HL7ParserTest < Minitest::Test
  def setup
    @klass = HL7::Parser.new(fd: '|', cd: '^', rd: '~', sd: '&')
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
      assert_equal expectation, @klass.send(parse_method).parse(input)
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
      input: 'foo^bar',
      expectation: [
        { component: [{ sub_component: 'foo' }] },
        { component: [{ sub_component: 'bar' }] }
      ],
      parse_method: :components
    },
    {
      parse_method: :repetition,
      input: 'foo^bar',
      expectation: {
        repetition: [
          { component: [{ sub_component: 'foo' }] },
          { component: [{ sub_component: 'bar' }] }
        ]
      }
    },
    {
      parse_method: :repetitions,
      input: 'foo^bar~baz^quxx',
      expectation: [
        { repetition: [
          { component: [{ sub_component: 'foo' }] },
          { component: [{ sub_component: 'bar' }] }
        ] },
        { repetition: [
          { component: [{ sub_component: 'baz' }] },
          { component: [{ sub_component: 'quxx' }] }
        ] }
      ]
    },
    {
      input: 'foo^bar&baz&^bing',
      expectation: {
        field: [{ repetition: [
          { component: [{ sub_component: 'foo' }] },
          { component: [
            { sub_component: 'bar' },
            { sub_component: 'baz' }
          ] },
          { component: [{ sub_component: 'bing' }] }
        ] }]
      },
      parse_method: :field
    },
    {
      input: 'spam|eggs',
      expectation: [
        { field: [
          { repetition: [{ component: [{ sub_component: 'spam' }] }] }
        ] },
        { field: [
          { repetition: [{ component: [{ sub_component: 'eggs' }] }] }
        ] }
      ],
      parse_method: :fields
    },
    {
      input: 'PV1|spam|green^eggs|knights^of&the^round|just&sub&components',
      expectation: {
        segment: {
          type: 'PV1',
          fields: [
            { field: [
              { repetition: [{ component: [{ sub_component: 'spam' }] }] }
            ] },
            { field: [{ repetition: [
              { component: [{ sub_component: 'green' }] },
              { component: [{ sub_component: 'eggs' }] }
            ] }] },
            { field: [{ repetition: [
              { component: [{ sub_component: 'knights' }] },
              {
                component: [{ sub_component: 'of' }, { sub_component: 'the' }]
              },
              { component: [{ sub_component: 'round' }] }
            ] }] },
            { field: [{ repetition: [
              { component: [
                { sub_component: 'just' },
                { sub_component: 'sub' },
                { sub_component: 'components' }
              ] }
            ] }] }
          ]
        }
      },
      parse_method: :segment
    },
    {
      parse_method: :msh_segment,
      input: 'MSH|^~\\&|another^field',
      expectation: {
        header: {
          type: 'MSH',
          char_sets: {
            field_delimiter: '|',
            component_delimiter: '^',
            repetition_delimiter: '~',
            escape: '\\',
            sub_component_delimiter: '&'
          },
          fields: [
            { field: [{ repetition: [
              { component: [{ sub_component: 'another' }] },
              { component: [{ sub_component: 'field' }] }] }]
            }
          ]
        }
      }
    },
    {
      parse_method: :message,
      input: "MSH|^~\\&|\rPID|foo|bar",
      expectation: {
        message: {
          header: {
            type: 'MSH',
            char_sets: {
              field_delimiter: '|',
              component_delimiter: '^',
              repetition_delimiter: '~',
              escape: '\\',
              sub_component_delimiter: '&'
            },
            fields: [] },
          segments: [
            { segment: {
              type: 'PID',
              fields: [
                { field: [
                  { repetition: [{ component: [{ sub_component: 'foo' }] }] }
                ] },
                { field: [
                  { repetition: [{ component: [{ sub_component: 'bar' }] }] }
                ] }
              ] }
            }
          ]
        }
      }
    }
  ].each do |h|
    equality_test_for(h)
  end
end
