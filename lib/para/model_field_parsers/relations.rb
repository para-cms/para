module Para
  module ModelFieldParsers
    class Relations < Para::ModelFieldParsers::Base
      register :relations, self

      def parse!
        # Catch multi select inputs from form attributes mappings
        find_attributes_for_mapping(:multi_select).each do |attribute|
          fields_hash[attribute] = AttributeField::HasManyField.new(
            model, name: attribute, type: 'has_many', field_type: 'multi_select'
          )
        end

        # Catch multi select inputs from form attributes mappings
        find_attributes_for_mapping(:nested_many).each do |attribute|
          fields_hash[attribute] = AttributeField::NestedManyField.new(
            model, name: attribute, type: 'has_many', field_type: 'nested_many'
          )
        end

        model.reflections.each do |name, reflection|
          # We ensure that name is a symbol and not a string for 4.2+
          # versions of AR
          # We may find a better solution to handle strings, since our
          # `fields_hash` is already a `HashWithIndifferentAccess`
          name = name.to_sym

          # Do not process component relations
          next if name == :component
          # Do not reprocess attributes that were already catched with
          # attributes mappings above
          next if AttributeField::RelationField == fields_hash[name]

          # Remove foreign key, if existing, from fields
          fields_hash.delete(reflection.foreign_key.to_s)

          # Do not process polymorphic belongs to for now ...
          if reflection.options[:polymorphic] == true
            fields_hash.delete(reflection.foreign_type.to_s)
            next
          end

          if model.nested_attributes_options[name]
            if reflection.collection?
              fields_hash[name] = AttributeField::NestedManyField.new(
                model, name: name, type: 'has_many', field_type: 'nested_many'
              )
            else
              fields_hash[name] = AttributeField::NestedOneField.new(
                model, name: name, type: 'belongs_to', field_type: 'nested_one'
              )
            end
          else
            if reflection.collection?
              remove_counter_cache_column!(name, reflection)

              fields_hash[name] = AttributeField::HasManyField.new(
                model, name: name, type: 'has_many', field_type: 'multi_select'
              )
            elsif !reflection.options[:through]
              fields_hash[name] = AttributeField::BelongsToField.new(
                model, name: name, type: 'belongs_to', field_type: 'selectize'
              )
            end
          end
        end
      end

      # Allows removing counter cache columns from fields from has_many
      # relations, when :inverse_of option is set
      #
      def remove_counter_cache_column!(name, reflection)
        return unless (inverse_relation = reflection.inverse_of)
        return unless (counter_name = inverse_relation.options[:counter_cache])

        counter_name = if String === counter_name
          counter_name
        else
          "#{ name }_count"
        end

        fields_hash.delete(counter_name)
      end
    end
  end
end
