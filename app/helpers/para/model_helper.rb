module Para
  module ModelHelper
    def attribute_field_mappings_for(component, relation)
      model = relation_klass_for(component, relation)
      model_field_mappings(model).fields
    end

    def model_field_mappings(model, attributes = nil)
      store_key = ['model', 'mappings', model.name.underscore].join(':')

      Para.store[store_key] ||= Para::AttributeFieldMappings.new(
        model, whitelist_attributes: attributes
      )
    end

    def relation_klass_for(component, relation)
      component.class.reflect_on_association(relation).klass
    end

    def field_value_for(object, field_name, type = nil)
      field = model_field_mappings(object.class).field_for(field_name, type)
      value = field.value_for(object)
      excerpt_value_for(value)
    end

    def excerpt_value_for(value)
      return value unless value.kind_of?(String)

      # Check wether the string is HTML or contains whitespace.
      # If so, use `truncate_html` helper, else truncate the string
      # so no-whitespace string (URLs for example) display the beginning of
      # their value, and not "..."
      if value.match(/\s|<|>/)
        truncate_html(value)
      else
        if (truncated = value[0..100]) != value
          "#{ truncated }..."
        else
          value
        end
      end
    end
  end
end
