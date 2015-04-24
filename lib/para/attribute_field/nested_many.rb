module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      def parse_input(params)
        if (nested_attributes = params[nested_attributes_key])
          nested_attributes.each do |_, attributes|
            nested_model_mappings.parse_input(attributes)
          end
        end
      end

      def nested_model_mappings
        @nested_model_mappings ||= AttributeFieldMappings.new(reflection.klass)
      end

      def nested_attributes_key
        @nested_attributes_key ||= :"#{ reflection.foreign_key }_attributes"
      end
    end
  end
end
