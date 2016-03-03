module Para
  module ModelFieldParsers
    class Store < Para::ModelFieldParsers::Base
      register :json, self

      def parse!
        puts "model.stored_attributes ==> #{ model.stored_attributes.inspect }"

        model.stored_attributes.each do |store_key, field_names|
          fields_hash.delete(store_key)

          field_names.each do |field_name|
            fields_hash[field_name] = AttributeField::Base.new(
              model, name: field_name, type: :string
            )
          end
        end
      end

      def applicable?
        !model.stored_attributes.empty?
      end
    end
  end
end
