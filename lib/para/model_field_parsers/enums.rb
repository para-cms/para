module Para
  module ModelFieldParsers
    class Enums < Para::ModelFieldParsers::Base
      register :enums, self

      def parse!
        model.defined_enums.each do |key, _|
          fields_hash[key] = AttributeField::EnumField.new(
            model, name: key, type: 'enum'
          )
        end
      end

      def applicable?
        model.respond_to?(:defined_enums) && !model.defined_enums.empty?
      end
    end
  end
end
