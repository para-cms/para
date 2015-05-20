module Para
  module ModelFieldParsers
    class Globalize < Para::ModelFieldParsers::Base
      register :globalize, self

      def parse!
        fields_hash.delete(:translations)

        model.translated_attribute_names.each do |attribute_name|
          column = model.translation_class.columns_hash[attribute_name.to_s]

          fields_hash[column.name] = AttributeField::Translation.new(
            model, name: column.name, type: column.type
          )
        end
      end

      def applicable?
        defined?(Globalize) && model.translates?
      end
    end
  end
end
