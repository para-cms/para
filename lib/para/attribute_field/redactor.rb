module Para
  module AttributeField
    class Redactor < AttributeField::Base
      def initialize(model, options = {})
        options.reverse_merge!(type: 'text', field_type: 'redactor')
        super(model, options)
      end
    end
  end
end
