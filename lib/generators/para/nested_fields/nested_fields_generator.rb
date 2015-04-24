module Para
  class NestedFieldsGenerator < Para::Generators::NamedBase
    include Para::Admin::BaseHelper

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template(
        "_nested_fields.html.haml",
        "app/views/admin/#{ plural_namespaced_path }/_fields.html.haml"
      )
    end

    private

    def attributes
      @attributes ||= begin
        model = Para.const_get(class_name)
        AttributeFieldMappings.new(model).fields
      end
    end
  end
end
