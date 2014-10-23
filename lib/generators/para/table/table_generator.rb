module Para
  class TableGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    desc 'Para resources table generator'

    def generate_table
      template(
        "_table.html.haml",
        "app/views/admin/#{ plural_name }/_table.haml"
      )
    end

    private

    def attributes
      @attributes ||= begin
        model =
          begin
            Para.const_get(class_name)
          rescue
            class_name.classify.constantize
          end
        AttributeFieldMappings.new(model).fields
      end
    end

    def attributes_list
      @attributes_list ||= attributes.map do |field|
        field.name.to_sym.inspect
      end.join(', ')
    end
  end
end