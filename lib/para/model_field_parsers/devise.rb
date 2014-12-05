module Para
  module ModelFieldParsers
    class Devise < Para::ModelFieldParsers::Base
      register :devise, self

      def parse!
        hidden_fields.each(&fields_hash.method(:delete))

        added_fields.each do |key|
          fields_hash[key] = AttributeField::PasswordField.new(model, name: key)
        end
      end

      def applicable?
        fields_hash.key?(:encrypted_password)
      end

      private

      def hidden_fields
        [
          :encrypted_password,
          :password_salt,
          :reset_password_token,
          :remember_token
        ]
      end

      def added_fields
        [
          :password,
          :password_confirmation
        ]
      end
    end
  end
end
