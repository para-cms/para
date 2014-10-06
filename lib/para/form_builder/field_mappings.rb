module Para
  module FormBuilder
    module FieldMappings
      def fields
        @fields ||= template.model_field_mappings(object.class).fields
      end
    end
  end
end
