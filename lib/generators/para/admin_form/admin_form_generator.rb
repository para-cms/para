module Para
  class AdminFormGenerator < Rails::Generators::NamedBase
    include Para::Admin::BaseHelper

    source_root File.expand_path("../templates", __FILE__)

    def generate_form
      template "form.html.haml", "app/views/para/admin/#{ plural_name }/_form.html.haml"
    end

    private

    def attributes
      @attributes ||= begin
        model = Para.const_get(class_name)
        AttributeFieldMappings.new(model).fields
      end
    end
  end

  class AttributeFieldMappings
    UNEDITABLE_ATTRIBUTES = %w(id component_id created_at updated_at)
    PAPERCLIP_SUFFIXES = %w(file_name content_type file_size updated_at)

    attr_reader :model, :fields

    def initialize(model)
      @model = model

      process_fields!
    end

    def process_fields!
      @fields = model.columns.each_with_object({}) do |column, fields|
        # Reject uneditable attributes
        unless UNEDITABLE_ATTRIBUTES.include?(column.name)
          fields[column.name] = AttributeField.new(model, name: column.name)
        end
      end.with_indifferent_access

      handle_paperclip_fields!
    end

    def handle_paperclip_fields!
      if model.respond_to?(:attachment_definitions)
        model.attachment_definitions.each do |key, _|
          PAPERCLIP_SUFFIXES.each do |suffix|
            field_name = [key, suffix].join('_').to_sym
            @fields.delete(field_name)
          end

          @fields[key] = AttributeField.new(model, name: key, type: 'file')
        end
      end
    end
  end

  class AttributeField
    attr_reader :model, :name, :type, :field_method

    def initialize(model, options = {})
      @model = model
      @name = options[:name]
      @type = options[:type]
      determine_name_and_field_method!
    end

    def determine_name_and_field_method!
      name = @name

      reference = model.reflect_on_all_associations.find do |association|
        association.foreign_key == name
      end

      if reference
        @name = reference.name
        @field_method = :association
      else
        @name = name
        @field_method = :input
      end
    end
  end
end
