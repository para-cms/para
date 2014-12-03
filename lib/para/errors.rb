module Para
  class BaseException < StandardError; end

  class ComponentNotFound < BaseException
    attr_accessor :type

    def initialize(type)
      @type = type
    end

    def message
      "Component not found for type : #{ type }"
    end
  end
end
