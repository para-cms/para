require_dependency "para/application_controller"

module Para
  module Admin
    class CrudResourcesController < Para::Admin::ResourcesController
      before_filter :load_and_authorize_crud_resource

      private

      def resource_model
        @resource_model ||= @component.model
      end

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, resource_name, parent: false, class: resource_model.name
        )

        loader.load_and_authorize_resource
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
