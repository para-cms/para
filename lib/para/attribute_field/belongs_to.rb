module Para
  module AttributeField
    class BelongsToField < RelationField
      def field_name
        model.reflections[name.to_s].foreign_key
      end

      def value_for(instance)
        if (resource = instance.send(name))
          resource_name(resource)
        end
      end
    end
  end
end
