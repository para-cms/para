module Para
  module AttributeField
    class HasManyField < RelationField
      def value_for(instance)
        instance.send(name).map do |resource|
          resource_name(resource)
        end.join(', ')
      end

      def parse_input(params)
        if (ids = params[foreign_key]) && String === ids
          params[foreign_key] = ids.split(',')
        end
      end
    end
  end
end
