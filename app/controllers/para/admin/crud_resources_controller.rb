require_dependency "para/application_controller"

module Para
  module Admin
    class CrudResourcesController < Para::Admin::ResourcesController
      include Para::Admin::ResourceControllerConcerns

      before_filter :load_and_authorize_crud_resource
      after_filter :attach_resource_to_component, only: [:create]
      after_filter :remove_resource_from_component, only: [:destroy]

      private

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, resource_name, parent: false, class: resource_model.name
        )

        loader.load_and_authorize_resource
      end

      def attach_resource_to_component
        return unless resource.persisted? && @component.namespaced?
        @component.add_resource(resource)
      end

      def remove_resource_from_component
        return unless @component.namespaced?
        @component.remove_resource(resource)
      end
    end
  end
end
