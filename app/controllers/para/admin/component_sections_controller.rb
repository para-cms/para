require_dependency "para/application_controller"

module Para
  module Admin
    class ComponentSectionsController < Para::Admin::BaseController
      load_and_authorize_resource class: 'Para::ComponentSection'

      def new
      end

      def create
        if @component_section.save
          flash_message(:success, @component_section)
          redirect_to admin_path
        else
          flash_message(:error, @component_section)
          render 'new'
        end
      end

      def edit
      end

      def update
        if @component_section.update_attributes(component_section_params)
          flash_message(:success, @component_section)
          redirect_to admin_path
        else
          flash_message(:error, @component_section)
          render 'new'
        end
      end

      def destroy
        @component_section.destroy
        flash_message(:success, @component_section)
        redirect_to admin_path
      end

      private

      def component_section_params
        params.require(:component_section).permit(:name)
      end
    end
  end
end
