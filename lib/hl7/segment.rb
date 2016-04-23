module HL7
  # HL7v2.3.1 Standard section 2.5
  class Segment
    attr_reader :fields, :type

    def initialize(fields: [], type: nil)
      raise ArgumentError, "Type must be 3 characters long: #{type}" unless type.length == 3
      @fields = fields
      @type = type
    end

    def length
      fields.length
    end

    def to_s(delimiter: '|')
      fields.unshift(type).join(delimiter)
    end
  end
end
