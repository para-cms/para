module Para
  module AttributeField
    class RelationField < AttributeField::Base
      private

      def reflection
        @reflection ||= model.reflections[name]
      end

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
