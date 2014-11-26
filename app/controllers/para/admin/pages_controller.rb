require_dependency "para/application_controller"

module Para
  module Admin
    class PagesController < Para::Admin::ResourcesController
      resource :page, parent: false, class: 'Para::Page',
                      find_by: :slug, though: :component
    end
  end
end
