module Para
  class TableGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para table generator'

    def generate_form
      template "_table.haml", "app/views/admin/#{ plural_name }/_table.haml"
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