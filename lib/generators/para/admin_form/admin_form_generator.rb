module Para
  class AdminFormGenerator < Rails::Generators::NamedBase
    include Para::Admin::BaseHelper

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template "form.html.haml", "app/views/admin/#{ plural_name }/_form.html.haml"
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
