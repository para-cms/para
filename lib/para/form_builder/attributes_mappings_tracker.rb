module Para
  module FormBuilder
    module AttributesMappingsTracker
      extend ActiveSupport::Concern

      included do
        attr_reader :attributes_mappings

        alias_method_chain :input, :mappings_tracking
        alias_method_chain :input_field, :mappings_tracking
        alias_method_chain :fields_for, :mappings_tracking
      end

      def initialize(*) #:nodoc:
        @attributes_mappings = {}

        super
      end

      def input_with_mappings_tracking(attribute_name, options = {}, &block)
        store_attribute_mapping_for(attribute_name, options, &block)

        input_without_mappings_tracking(attribute_name, options, &block)
      end

      def input_field_with_mappings_tracking(attribute_name, options = {})
        store_attribute_mapping_for(attribute_name, options)

        input_field_without_mappings_tracking(attribute_name, options)
      end

      def fields_for_with_mappings_tracking(*args, options, &block)
        fields_for_without_mappings_tracking(*args, options) do |fields|
          fields.attributes_mappings_field +
          block.call(fields)
        end
      end

      def attributes_mappings_field
        hidden_field :_attributes_mappings, value: attributes_mappings.to_json
      end

      private

      def store_attribute_mapping_for(attribute_name, options, &block)
        input = find_input(attribute_name, options, &block)
        type = input.class.name.demodulize.underscore.gsub(/_input\z/, '')

        attributes_mappings[attribute_name] = type
      end
    end
  end
end
