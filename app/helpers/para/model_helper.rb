module Para
  module ModelHelper
    def attribute_field_mappings_for(component, relation)
      model = relation_klass_for(component, relation)
      model_field_mappings(model).fields
    end

    def model_field_mappings(model)
      store_key = ['model', 'mappings', model.name.underscore].join(':')
      Para.store[store_key] ||= Para::AttributeFieldMappings.new(model)
    end

    def relation_klass_for(component, relation)
      component.class.reflections[relation.to_sym].klass
    end

    def field_value_for(model, field_name)
      model_mappings = model_field_mappings(model.class)
      model_mappings.fields_hash[field_name.to_sym].value_for(model)
    end
  end
end