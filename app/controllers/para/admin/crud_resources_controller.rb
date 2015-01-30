require_dependency "para/application_controller"

module Para
  module Admin
    class CrudResourcesController < Para::Admin::ResourcesController
      include Para::Admin::ResourceControllerConcerns

      before_filter :load_and_authorize_crud_resource

      private

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, resource_name, parent: false, class: resource_model.name
        )

        loader.load_and_authorize_resource
      end
    end
  end
end
