module HL7
  class SubComponent
    attr_reader :content
    def initialize(content: nil)
      @content = content
    end

    def to_s
      content.to_s
    end
  end
end
