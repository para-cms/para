require_dependency "para/application_controller"

module Para
  module Admin
    class PagesController < Para::Admin::ResourcesController
      load_and_authorize_resource :page, parent: false, class: 'Para::Page',
                                  find_by: :slug, though: :component

      # def new

      # end

      # def create
      #   if @page.save
      #     flash_message(:success, @page)
      #     redirect_to component_path(@component)
      #   else
      #     flash_message(:error, @page)
      #     render 'new'
      #   end
      # end

      # def edit
      #   @page = Para::Page.find(params[:id])
      # end

      # def update
      #   @page = Para::Page.find(params[:id])

      #   if @page.update_attributes(page_params)
      #     flash_message(:success, @page)
      #     redirect_to component_path(@component)
      #   else
      #     flash_message(:error, @page)
      #     render 'edit'
      #   end
      # end

      private

      # def page_params
      #   @page_params ||= params.require(:page).permit(
      #     :title, :slug, :content, :component_id
      #   )
      # end

      def resource
        @page
      end
    end
  end
end
