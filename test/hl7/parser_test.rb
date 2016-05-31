require 'test_helper'
require 'hl7/parser'
require 'pry'

class HL7ParserTest < Minitest::Test
  describe 'Parser' do
    before do
      @klass = HL7::Parser.new(fd: '|', cd: '^', rd: '~', sd: '&')
    end

    describe '#sub_component' do
      it 'should parse a single sub_component' do
        response = @klass.send(:sub_component).parse('foo')
        expectation = { sub_component: 'foo' }
        assert_equal expectation, response
      end
    end

    describe '#sub_components' do
      it 'should parse mutliple sub_components' do
        response = @klass.send(:sub_components).parse('foo&bar&')
        expectation = [
          { sub_component: 'foo' },
          { sub_component: 'bar' }
        ]
        assert_equal expectation, response
      end
    end
    describe '#component' do
      it 'should contain child sub_components' do
        response = @klass.send(:component).parse('foo&bar')
        expectation = { component: [
          { sub_component: 'foo' },
          { sub_component: 'bar' }
        ] }
        assert_equal expectation, response
      end
    end
    describe '#components' do
      it 'should parse multiple components' do
        response = @klass.send(:components).parse('foo^bar')
        expectation = [
          { component: [{ sub_component: 'foo' }] },
          { component: [{ sub_component: 'bar' }] }
        ]
        assert_equal expectation, response
      end
    end
    describe '#repetition' do
      it 'should contain child components' do
        response = @klass.send(:repetition).parse('foo^bar')
        expectation = {
          repetition: [
            { component: [{ sub_component: 'foo' }] },
            { component: [{ sub_component: 'bar' }] }
          ]
        }
        assert_equal expectation, response
      end
    end

    describe '#repetitions' do
      it 'should parse multiple repetitions' do
        response = @klass.send(:repetitions).parse('foo^bar~baz^quxx')
        expectation = [
          { repetition: [
            { component: [{ sub_component: 'foo' }] },
            { component: [{ sub_component: 'bar' }] }
          ] },
          { repetition: [
            { component: [{ sub_component: 'baz' }] },
            { component: [{ sub_component: 'quxx' }] }
          ] }
        ]
        assert_equal expectation, response
      end
    end

    describe '#field' do
      it 'should container child repetitions' do
        response = @klass.send(:field).parse('foo^bar&baz&^bing')
        expectation = {
          field: [{ repetition: [
            { component: [{ sub_component: 'foo' }] },
            { component: [
              { sub_component: 'bar' },
              { sub_component: 'baz' }
            ] },
            { component: [{ sub_component: 'bing' }] }
          ] }]
        }
        assert_equal expectation, response
      end
    end

    describe '#fields' do
      it 'should parse multiple fields' do
        response = @klass.send(:fields).parse('spam|eggs')
        expectation = [
          { field: [
            { repetition: [{ component: [{ sub_component: 'spam' }] }] }
          ] },
          { field: [
            { repetition: [{ component: [{ sub_component: 'eggs' }] }] }
          ] }
        ]
        assert_equal expectation, response
      end
    end
  #   },
  #   {
  #     input: 'PV1|spam|green^eggs|knights^of&the^round|just&sub&components',
  #     expectation: {
  #       segment: {
  #         type: 'PV1',
  #         fields: [
  #           { field: [
  #             { repetition: [{ component: [{ sub_component: 'spam' }] }] }
  #           ] },
  #           { field: [{ repetition: [
  #             { component: [{ sub_component: 'green' }] },
  #             { component: [{ sub_component: 'eggs' }] }
  #           ] }] },
  #           { field: [{ repetition: [
  #             { component: [{ sub_component: 'knights' }] },
  #             {
  #               component: [{ sub_component: 'of' }, { sub_component: 'the' }]
  #             },
  #             { component: [{ sub_component: 'round' }] }
  #           ] }] },
  #           { field: [{ repetition: [
  #             { component: [
  #               { sub_component: 'just' },
  #               { sub_component: 'sub' },
  #               { sub_component: 'components' }
  #             ] }
  #           ] }] }
  #         ]
  #       }
  #     },
  #     parse_method: :segment
  #   },
  #   {
  #     parse_method: :msh_segment,
  #     input: 'MSH|^~\\&|another^field',
  #     expectation: {
  #       header: {
  #         type: 'MSH',
  #         char_sets: {
  #           field_delimiter: '|',
  #           component_delimiter: '^',
  #           repetition_delimiter: '~',
  #           escape: '\\',
  #           sub_component_delimiter: '&'
  #         },
  #         fields: [
  #           { field: [{ repetition: [
  #             { component: [{ sub_component: 'another' }] },
  #             { component: [{ sub_component: 'field' }] }] }]
  #           }
  #         ]
  #       }
  #     }
  #   },
  #   {
  #     parse_method: :message,
  #     input: 	"MSH|^~\\&|\rPID|foo&sop^baz~foo2^ro|bar",
  #     expectation: {
  #       message: {
  #         header: {
  #           type: 'MSH',
  #           char_sets: {
  #             field_delimiter: '|',
  #             component_delimiter: '^',
  #             repetition_delimiter: '~',
  #             escape: '\\',
  #             sub_component_delimiter: '&'
  #           },
  #           fields: []
  #         },
  #         segments: [
  #           { segment: {
  #             type: 'PID',
  #             fields: [
  #               { field: [
  #                 { repetition: [
  #                   { component: [
  #                     { sub_component: 'foo' },
  #                     { sub_component: 'sop' }
  #                   ] },
  #                   { component: [
  #                     { sub_component: 'baz' }
  #                   ] }
  #                 ] },
  #                 { repetition: [
  #                   { component: [
  #                     { sub_component: 'foo2' }
  #                   ] },
  #                   { component: [
  #                     { sub_component: 'ro' }
  #                   ] }
  #                 ] }
  #               ] },
  #               { field: [
  #                 { repetition: [{ component: [{ sub_component: 'bar' }] }] }
  #               ] }
  #             ] }
  #           }
  #         ]
  #       }
  #     }
  #   }
  end
end
