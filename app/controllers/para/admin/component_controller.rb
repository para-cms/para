require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base',
                                  find_by: :slug

      def destroy
        if @component.destroy
          redirect_to admin_path
        end
      end
    end
  end
end
