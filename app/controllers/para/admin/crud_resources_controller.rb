require_dependency "para/application_controller"

module Para
  module Admin
    class CrudResourcesController < Para::Admin::ResourcesController
      include Para::Admin::ResourceControllerConcerns

      before_filter :load_and_authorize_crud_resource
      after_filter :attach_resource_to_component, only: [:create]
      after_filter :remove_resource_from_component, only: [:destroy]

      def clone
        new_resource = resource.deep_clone include: resource.class.cloneable_associations
        new_resource.save!

        if new_resource.save
          component_resource = Para::ComponentResource.where(
            resource: resource
          ).first

          if component_resource
            Para::ComponentResource.create! do |record|
              record.resource = new_resource
              record.component = component_resource.component
            end
          end

          flash_message(:success, new_resource)
          redirect_to after_form_submit_path
        else
          flash_message(:error, new_resource)
          render after_form_submit_path
        end
      end

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
