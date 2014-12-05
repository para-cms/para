require_dependency "para/application_controller"

module Para
  module Admin
    class PageCategoryComponentController < Para::Admin::ComponentController
      def show
        @q = @component.pages.search(params[:q])
        @pages = @q.result.page(params[:page]).per(10)
      end
    end
  end
end
