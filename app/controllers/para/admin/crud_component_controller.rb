require_dependency "para/application_controller"

module Para
  module Admin
    class CrudComponentController < Para::Admin::ComponentController
      def show
        @q = @component.resources.search(params[:q])
        @resources = @q.result.page(params[:page])

        # Sort collection for orderable and trees
        @resources = @resources.ordered if @resources.respond_to?(:ordered)
      end
    end
  end
end
