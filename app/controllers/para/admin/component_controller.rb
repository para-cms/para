require_dependency 'para/application_controller'

module Para
  module Admin
    class ComponentController < Para::Admin::BaseController
      load_and_authorize_component

      def destroy
        if @component.destroy
          flash_message :success, @component
          redirect_to admin_path
        else
          flash_message :error, @component
          redirect_to @component.path
        end
      end
    end
  end
end
