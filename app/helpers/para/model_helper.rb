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

    def field_for(model, field_name, type = nil)
      model_field_mappings(model).field_for(field_name, type)
    end

    def value_for(object, field_name, type = nil)
      field = field_for(object.class, field_name, type)
      field.value_for(object)
    end

    def field_value_for(object, field_name, type = nil)
      field = field_for(object.class, field_name, type)
      value = field.value_for(object)

      if field.excerptable_value?
        excerpt_value_for(value)
      else
        value
      end
    end

    def excerpt_value_for(value)
      return value unless value.kind_of?(String)

      value = sanitize(value, tags: [])

      if (truncated = value[0..100]) != value
        "#{ truncated }..."
      else
        value
      end
    end
  end
end
