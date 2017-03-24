module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      include Para::AttributesMappingsHelper

      register :nested_many, self

      def parse_input(params, resource)
        if (nested_attributes = params[nested_attributes_key])
          nested_attributes.each do |index, attributes|
            mappings = nested_model_mappings(attributes)
            nested_resource = fetch_or_build_nested_resource_for(resource, index, attributes)

            mappings.fields.each do |field|
              field.parse_input(attributes, nested_resource)
            end

            params[nested_attributes_key][index] = attributes
          end
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

      # Force loading association and look for a resource matching the provided
      # attributes. If no resource is found, one is created and a fake `id` is
      # assigned to it to hack Rails' nested resources lookup from new
      # attributes params.
      #
      # This is necessary to be able to provide a resource to the #parse_input
      # method when called on the nested resources hash
      #
      def fetch_or_build_nested_resource_for(parent, index, attributes)
        nested_resources = parent.association(name).load_target

        if (id = attributes['id'].presence)
          nested_resources.find { |res| res.id == id.to_i }
        else
          parent.association(name).build(attributes.slice('type')).tap do |resource|
            attributes['id'] = "__#{ index }"
            # Note : This hack could break if the current method is called
            #        in a way it was not meant to (in a Para resource controller
            #        assignation process) but seemed to be the only way not to
            #        override Rails nested fields assignation, which is a
            #        huge method that we cannot split and that raised in our
            #        use case
            resource.define_singleton_method(:id) { attributes['id'] }
          end
        end
      end
    end
  end
end
