module HL7
  class Component
    attr_reader :sub_components

    def initialize(sub_components: [])
      @sub_components = sub_components
    end

    def length
      sub_components.length
    end

    def to_s(delimiter: '&')
      sub_components.join(delimiter)
    end
  end
end
