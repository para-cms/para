module Para
  module ModelFieldParsers
    class Relations < Para::ModelFieldParsers::Base
      register :relations, self

      def parse!
        model.reflections.each do |name, reflection|
          next if name == :component

          if model.nested_attributes_options[name]
            if reflection.collection?
              fields_hash[name] = AttributeField::NestedManyField.new(
                model, name: name, type: 'has_many', field_type: 'nested_many'
              )
            end
          end
        end
      end
    end
  end
end
