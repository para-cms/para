module Para
  module AttributeField
    class NestedOneField < AttributeField::BelongsToField
      register :nested_one, self

      def parse_input(params)
        if (nested_attributes = params[nested_attributes_key])
          nested_model_mappings.fields.each do |field|
            field.parse_input(nested_attributes)
          end

          params[nested_attributes_key] = nested_attributes
        else
          super(params)
        end
      end

      def nested_model_mappings
        @nested_model_mappings ||= AttributeFieldMappings.new(reflection.klass)
      end

      def nested_attributes_key
        @nested_attributes_key ||= :"#{ name }_attributes"
      end
    end
  end
end
