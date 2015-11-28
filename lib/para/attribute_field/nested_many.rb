module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      register :nested_many, self

      def parse_input(params)
        if (nested_attributes = params[nested_attributes_key])
          nested_attributes.each do |index, attributes|
            nested_model_mappings.fields.each do |field|
              field.parse_input(attributes)
            end
            params[nested_attributes_key][index] = attributes
          end
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
