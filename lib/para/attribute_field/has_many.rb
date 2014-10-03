module Para
  module AttributeField
    class HasManyField < AttributeField::Base
      def value_for(instance)
        instance.send(name).map do |resource|
          resource_name(resource)
        end.join(', ')
      end

      private

      def resource_name(resource)
        [:name, :title].each do |method|
          return resource.send(method) if resource.respond_to?(method)
        end

        model_name = resource.class.model_name.human
        "#{ model_name } - #{ resource.id }"
      end
    end
  end
end
