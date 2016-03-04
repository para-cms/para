require_dependency "para/application_controller"

module Para
  module Admin
    class CrudComponentController < Para::Admin::ComponentController
      def show
        @q = @component.resources.search(params[:q])
        @resources = @q.result.uniq.page(params[:page])

        # Sort collection for orderable and trees
        @resources = if @resources.respond_to?(:ordered)
          @resources.ordered
        else
          @resources.order(created_at: :desc)
        end
      end
    end
  end
end
