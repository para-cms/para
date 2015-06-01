module Para
  class NestedFieldsGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path("../templates", __FILE__)

    def generate_fields
      template(
        "_nested_fields.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_fields.html.haml"
      )
    end
  end
end
