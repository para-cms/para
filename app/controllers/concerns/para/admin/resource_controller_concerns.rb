module Para
  module Admin
    module ResourceControllerConcerns
      def resource_model
        @resource_model ||= @component.model
      end

      def resource
        @resource ||= instance_variable_get(:"@#{ resource_name }")
      end

      def resource_name
        resource_model.model_name.singular_route_key
      end

      def parse_resource_params(hash)
        model_field_mappings(resource_model).fields.each do |field|
          field.parse_input(hash) if hash.key?(field.name)
        end

        hash
      end
    end
  end
end
