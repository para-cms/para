module Para
  class FiltersGenerator < Para::Generators::NamedBase
    include Para::SearchHelper
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template(
        "_filters.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_filters.html.haml"
      )
    end
  end
end
