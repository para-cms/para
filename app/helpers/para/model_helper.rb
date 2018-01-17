module Para
  module ModelHelper
    def attribute_field_mappings_for(component, relation)
      model = relation_klass_for(component, relation)
      model_field_mappings(model).fields
    end

    # Second argument can be the whitelist_attributes array or keyword
    # arguments. This is to ensure backwards compatibility with old plugins.
    #
    def model_field_mappings(model, options = {})
      if Array == options
        whitelist_attributes = options
      else
        whitelist_attributes = options.fetch(:whitelist_attributes, nil)
        mappings = options.fetch(:mappings, {})
      end

      Para::AttributeFieldMappings.new(
        model, whitelist_attributes: whitelist_attributes, mappings: mappings
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
