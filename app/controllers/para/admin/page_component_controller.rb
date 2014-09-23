require_dependency "para/application_controller"

module Para
  module Admin
    class PageComponentController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base'

      def show
        @page = @component.page
      end
    end
  end
end
