module Para
  class NestedFieldsGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper
    include Para::Generators::FieldHelpers

    source_root File.expand_path("../templates", __FILE__)

    class_option :container, type: :boolean, default: false, :aliases => "-c"

    def generate_fields
      template(
        "_nested_fields.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_fields.html.haml"
      )
    end

    def generate_fields_container
      template(
        "../../../../../app/views/para/inputs/nested_many/_container.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/nested_many/_container.html.haml"
      ) if options[:container]
    end
  end
end
