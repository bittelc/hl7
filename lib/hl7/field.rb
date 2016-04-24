module HL7
  class Field
    attr_reader :components

    def initialize(components: [[]])
      @components = components
    end

    def repetitions
      components.length
    end

    def length
      components.first.length
    end

    def [](i)
      components[i]
    end

    alias fetch []

    def to_s(delimiter: '^', repetition: '~')
      components.map { |e| e.join(delimiter) }.join(repetition)
    end
  end
end
