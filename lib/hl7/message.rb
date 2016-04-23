module HL7
  class Message
    attr_reader :delimiter, :segments

    def initialize(segments: [])
      @delimiter = delimiter
      @segments = segments
    end

    def length
      segments.length
    end

    def to_s(delimiter: "\n")
      segments.join(delimiter)
    end
  end
end
