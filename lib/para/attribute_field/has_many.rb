module Para
  module AttributeField
    class HasManyField < RelationField
      def value_for(instance)
        instance.send(name).map do |resource|
          resource_name(resource)
        end.join(', ')
      end

      def parse_input(params)
        if (ids = params[plural_foreign_key].presence) && String === ids
          # Format selectize value for Rails
          ids = params[plural_foreign_key] = ids.split(',')

          on_the_fly_creation(ids) do |resource, value|
            params[plural_foreign_key].delete(value)
            params[plural_foreign_key] << resource.id
          end
        end 
      end

      def plural_foreign_key
        foreign_key.to_s.pluralize
      end
    end
  end
end
