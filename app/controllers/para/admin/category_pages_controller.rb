require_dependency "para/application_controller"

module Para
  module Admin
    class CategoryPagesController < Para::Admin::ResourcesController
      load_and_authorize_resource :page, parent: false, class: 'Para::Page',
                                         find_by: :slug

      protected

      def resource
        @page
      end
    end
  end
end
