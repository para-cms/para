require_dependency "para/application_controller"

module Para
  module Admin
    class CrudComponentController < Para::Admin::BaseController
      load_and_authorize_resource :component, class: 'Para::Component::Base'

      def show
        @q = @component.model.search(params[:q])
        @resources = @q.result.page(params[:page])
      end
    end
  end
end
