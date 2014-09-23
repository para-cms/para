require_dependency "para/application_controller"

module Para
  module Admin
    class PageController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base'

      load_and_authorize_resource :page, parent: false, class: 'Para::Page'

      def update
        @page = @component.page

        if @page.update_attributes(page_params)
          flash_message(:success, @page)
          redirect_to component_path(@component)
        else
          flash_message(:error, @page)
          render 'edit'
        end
      end

      private

      def page_params
        @page_params ||= params.require(:page).permit(:title, :slug, :content)
      end

      def resource
        @page
      end
    end
  end
end
