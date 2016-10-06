module Para
  module Admin
    module ResourceControllerConcerns
      def resource_model
        @resource_model ||= @component.try(:model)
      end

      def resource
        @resource ||= instance_variable_get(:"@#{ resource_name }")
      end

      def resource_name
        resource_model.model_name.singular_route_key
      end
    end
  end
end
