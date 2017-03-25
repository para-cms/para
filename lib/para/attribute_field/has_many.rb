module Para
  module AttributeField
    class HasManyField < RelationField
      register :has_many, self

      def field_name
        reflection.name
      end

      def value_for(instance)
        instance.send(name).map do |resource|
          resource_name(resource)
        end.join(', ')
      end

      def parse_input(params, resource)
        if (ids = params[plural_foreign_key].presence) && String === ids
          # Format selectize value for Rails
          ids = params[plural_foreign_key] = ids.split(',').map(&:to_i)

          on_the_fly_creation(ids) do |res, value|
            params[plural_foreign_key].delete(value)
            params[plural_foreign_key] << res.id
          end
        end

        assign_ids(params, resource)
      end

      def plural_foreign_key
        foreign_key.to_s.pluralize
      end

      def assign_ids(params, resource)
        return unless Array === params[plural_foreign_key]

        ids = params.delete(plural_foreign_key)

        if through_reflection && through_reflection.klass.orderable?
          assign_ordered_through_reflection_ids(through_reflection, resource, ids)
        else
          resource.assign_attributes(plural_foreign_key => ids)
        end
      end

      def assign_ordered_through_reflection_ids(through_reflection, resource, ids)
        association = resource.association(through_reflection.name)
        join_resources = association.load_target

        return association.replace([]) if ids.empty?

        new_resources = ids.each_with_index.map do |id, position|
          join_resource = join_resources.find do |res|
            res.send(through_relation_source_foreign_key) == id &&
              (!polymorphic_through_reflection? || res.send(reflection.foreign_type) == reflection.klass.name)
          end

          unless join_resource
            attributes = { through_relation_source_foreign_key => id }
            attributes[reflection.foreign_type] = reflection.klass.name if polymorphic_through_reflection?
            join_resource = association.build(attributes)
          end

          join_resource.position = position
          join_resource
        end

        association.replace(new_resources)
      end
    end
  end
end
