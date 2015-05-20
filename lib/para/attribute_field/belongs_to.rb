module Para
  module AttributeField
    class BelongsToField < RelationField
      field_option :collection, :relation_options

      def field_name
        reflection.name
      end

      def value_for(instance)
        if (resource = instance.send(name))
          resource_name(resource)
        end
      end

      def relation_options
        reflection.klass.all
      end

      def parse_input(params)
        if (id = params[reflection.foreign_key].presence) && !reflection.klass.exists?(id: id)
          on_the_fly_creation(id) do |resource|
            params[reflection.foreign_key] = resource.id
          end
        end
      end
    end
  end
end
