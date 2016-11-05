module Para
  module Admin
    module ResourceControllerConcerns
      def resource_model
        @resource_model ||= @component.try(:model)
      end

      def resource
        @resource ||= begin
          resource = instance_variable_get(:"@#{ resource_name }")
          # We ensure that the fetched resource is not a relation, which could
          # happen for uncountable resource names (like "news") and would make
          # code depending on the `resource` getter to fail unexpectedly
          resource unless ActiveRecord::Relation === resource
        end
      end

      def resource_name
        resource_model.model_name.singular_route_key
      end
    end
  end
end
