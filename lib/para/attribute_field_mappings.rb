module Para
  class AttributeFieldMappings
    UNEDITABLE_ATTRIBUTES = %w(id component_id created_at updated_at type)

    attr_reader :model, :fields_hash, :whitelist_attributes, :mappings

    def initialize(model, whitelist_attributes: nil, mappings: nil)
      @model = model
      @whitelist_attributes = whitelist_attributes
      @mappings = mappings || {}

      process_fields!
    end

    def fields
      fields_hash.values
    end

    def field_for(field_name, type = nil)
      existing_field = fields_hash[field_name]

      if !existing_field || (type && !existing_field.type?(type))
        fields_hash[field_name] = if model.new.respond_to?(field_name)
          build_field_for(field_name, type)
        else
          raise NoMethodError.new(
            "No attribute or method correspond to ##{ field_name } " +
            "in the model #{ model.name }. No field could be created."
          )
        end
      else
        existing_field
      end
    end

    private

    def whitelisted?(attribute_name)
      !whitelist_attributes || whitelist_attributes.include?(attribute_name)
    end

    def process_fields!
      @fields_hash = model.columns.each_with_object({}) do |column, fields|
        next unless whitelisted?(column.name)

        # Reject uneditable attributes
        unless UNEDITABLE_ATTRIBUTES.include?(column.name)
          field_class = field_class_for(column.type)

          fields[column.name] = field_class.new(
            model, name: column.name, type: column.type
          )
        end
      end.with_indifferent_access

      Para::ModelFieldParsers.parse!(model, fields_hash, mappings)
    end

    def build_field_for(attribute_name, type)
      field_class = field_class_for(type)
      field_class.new(model, name: attribute_name, type: type)
    end

    def field_class_for(type)
      attribute_class = type && AttributeField::Base.field_types[type.to_sym]
      attribute_class || AttributeField::Base
    end
  end
end
