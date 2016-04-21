module Para
  module ModelFieldParsers
    class Store < Para::ModelFieldParsers::Base
      register :json, self

      def parse!
        process_stored_attributes
        process_remaining_json_fields
      end

      def process_stored_attributes
        model.stored_attributes.each do |store_key, field_names|
          fields_hash.delete(store_key)

          field_names.each do |field_name|
            fields_hash[field_name] = AttributeField::Base.new(
              model, name: field_name, type: :string
            )
          end
        end
      end

      # Duplicate fields to avoid updating the hash while iterating through it
      # then remove remaining json fields from the hash
      def process_remaining_json_fields
        fields_hash.dup.each do |key, field|
          fields_hash.delete(key) if json_field?(field)
        end
      end

      def applicable?
        !model.stored_attributes.empty? || model_includes_json_fields?
      end

      def model_includes_json_fields?
        fields_hash.any? do |_, field|
          json_field?(field)
        end
      end

      def json_field?(field)
        field.type.to_s.in?(%w(json jsonb))
      end
    end
  end
end
