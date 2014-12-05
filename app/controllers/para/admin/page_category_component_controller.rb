require_dependency "para/application_controller"

module Para
  module Admin
    class PageCategoryComponentController < Para::Admin::ComponentController
      load_and_authorize_resource :page, class: 'Para::Page',
                                         parent: false,
                                         through: :component

      def show
        @q = @pages.search(params[:q])
        @pages = @q.result.page(params[:page])
      end
    end
  end
end
