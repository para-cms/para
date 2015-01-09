module Para
  class FormGenerator < Rails::Generators::NamedBase
    include Para::Admin::BaseHelper

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template(
        "_form.html.haml",
        "app/views/admin/#{ plural_name }/_form.html.haml"
      )
    end

    private

    def attributes
      @attributes ||= begin
        model = Para.const_get(class_name)
        AttributeFieldMappings.new(model).fields
      end
    end

    def field_options_for(field)
      field_options = field.field_options

      return '' if field_options.empty?

      options_string = field_options.map do |key, value|
        "#{ key.inspect } => #{ value.inspect }"
      end.join(', ')

      ", #{ options_string }"
    end
  end
end
