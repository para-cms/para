module Para
  module AttributeField
    class NestedOneField < AttributeField::BelongsToField
      include Para::Helpers::AttributesMappings

      register :nested_one, self

      def parse_input(params, resource)
        if (nested_attributes = params[nested_attributes_key])
          mappings = nested_model_mappings(nested_attributes)

          mappings.fields.each do |field|
            field.parse_input(nested_attributes)
          end

          params[nested_attributes_key] = nested_attributes
        else
          super
        end
      end

      def nested_model_mappings(nested_attributes)
        model = nested_attributes[:type].try(:constantize) || reflection.klass
        mappings = attributes_mappings_for(nested_attributes)

        @nested_model_mappings ||= AttributeFieldMappings.new(model, mappings: mappings)
      end

      def nested_attributes_key
        @nested_attributes_key ||= :"#{ name }_attributes"
      end
    end
  end
end
