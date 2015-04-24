module Para
  module AttributeField
    class RelationField < AttributeField::Base
      private

      def reflection
        @reflection ||= model.reflect_on_association(name)
      end

      def foreign_key
        @foreign_key ||= reflection.try(:foreign_key)
      end

      def resource_name(resource)
        Para.config.resource_name_methods.each do |method|
          return resource.send(method) if resource.respond_to?(method)
        end

        model_name = resource.class.model_name.human
        "#{ model_name } - #{ resource.id }"
      end
    end
  end
end
