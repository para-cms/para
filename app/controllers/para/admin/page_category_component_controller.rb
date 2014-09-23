require_dependency "para/application_controller"

module Para
  module Admin
    class PageCategoryComponentController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base'

      def show
        @pages = @component.pages
      end
    end
  end
end
