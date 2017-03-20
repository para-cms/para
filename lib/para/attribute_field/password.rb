module Para
  module AttributeField
    class PasswordField < AttributeField::Base
      register :password, self

      def initialize(model, options = {})
        options.reverse_merge!(type: 'password', field_type: 'password')
        super(model, options)
      end

      def value_for(instance)
        nil
      end

      def parse_input(params, resource)
        params[name] = params[name].presence
      end
    end
  end
end
