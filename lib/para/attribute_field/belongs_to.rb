module Para
  module AttributeField
    class BelongsToField < RelationField
      field_option :collection, :relation_options

      def field_name
        reflection.foreign_key
      end

      def value_for(instance)
        if (resource = instance.send(name))
          resource_name(resource)
        end
      end

      def relation_options
        reflection.klass.all
      end
    end
  end
end
