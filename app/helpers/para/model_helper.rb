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
      component.class.reflections[relation.to_sym].klass
    end

    def field_value_for(model, field_name)
      fields = model_field_mappings(model.class).fields_hash
      fields[field_name.to_sym].value_for(model)
    end
  end
end
