require_dependency "para/application_controller"

module Para
  module Admin
    class ResourcesController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base',
                                  find_by: :slug

      helper_method :resource

      def new
        render 'para/admin/resources/new'
      end

      def create
        resource.component = @component

        if resource.save
          flash_message(:success, resource)
          redirect_to component_path(@component)
        else
          flash_message(:error, resource)
          render 'new'
        end
      end

      def edit
        render 'para/admin/resources/edit'
      end

      def update
        if resource.update_attributes(resource_params)
          flash_message(:success, resource)
          redirect_to component_path(@component)
        else
          flash_message(:error, resource)
          render 'edit'
        end
      end

      def destroy
        resource.destroy
        flash_message(:success, resource)
        redirect_to component_path(@component)
      end

      private

      def resource_params
        @resource_params ||= params.require(:resource).permit!
      end
    end
  end
end
