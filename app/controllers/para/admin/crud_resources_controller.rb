require_dependency "para/application_controller"

module Para
  module Admin
    class CrudResourcesController < Para::Admin::ResourcesController
      include Para::Admin::ResourceControllerConcerns
      include Para::SearchHelper

      before_action :load_and_authorize_crud_resource
      before_action :add_breadcrumbs, only: [:show, :index, :edit, :new]

      after_action :attach_resource_to_component, only: [:create]
      after_action :remove_resource_from_component, only: [:destroy]

      def index
        @q = @component.resources.search(params[:q])
        @resources = distinct_search_results(@q).page(params[:page]).per(params[:per_page])

        # Sort collection for orderable and trees
        @resources = if @resources.respond_to?(:ordered)
          @resources.ordered
        else
          @resources.order(created_at: :desc)
        end
      end

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
          redirect_to @component.relation_path(new_resource, action: :edit)
        else
          flash_message(:error, new_resource)
          render after_form_submit_path
        end
      end

      private

      def resource_model
        @resource_model ||=
          if params[:type] && @component.subclassable_with?(params[:type])
            params[:type].constantize
          else
            super
          end
      end

      def load_and_authorize_crud_resource
        loader = self.class.cancan_resource_class.new(
          self, resource_name, parent: false, class: resource_model.name
        )

        loader.load_and_authorize_resource
      end

      def add_breadcrumbs
        add_breadcrumb(resource_title_for(resource), path_to_edit(resource)) if resource
      end

      def attach_resource_to_component
        return unless resource.persisted? && @component.namespaced?
        @component.add_resource(resource)
      end

      def remove_resource_from_component
        return unless @component.namespaced?
        @component.remove_resource(resource)
      end

      def path_to_edit(resource)
        @component.relation_path(
          resource, action: (resource.persisted? ? :edit : :new)
        )
      end
    end
  end
end
