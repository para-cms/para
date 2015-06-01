module Para
  class FormGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template(
        "_form.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_form.html.haml"
      )
    end
  end
end
