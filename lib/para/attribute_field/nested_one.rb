module Para
  module AttributeField
    class NestedOneField < AttributeField::BelongsToField
      include Para::Helpers::AttributesMappings
      include Para::AttributeField::NestedField

      register :nested_one, self

      def parse_input(params, resource)
        if (nested_attributes = params[nested_attributes_key])
          nested_resource = fetch_or_build_nested_resource_for(resource, nested_attributes)
          mappings = nested_model_mappings(nested_attributes, nested_resource)

          mappings.fields.each do |field|
            field.parse_input(nested_attributes, nested_resource)
          end

          params[nested_attributes_key] = nested_attributes
        else
          super
        end
      end

      private

      # Force loading association and look for a resource matching the provided
      # attributes. If no resource is found, one is created and a fake `id` is
      # assigned to it to hack Rails' nested resources lookup from new
      # attributes params.
      #
      # This is necessary to be able to provide a resource to the #parse_input
      # method when called on the nested resources hash
      #
      def fetch_or_build_nested_resource_for(parent, attributes)
        if (nested_resource = parent.association(name).load_target)
          return nested_resource
        end

        parent.association(name).build(attributes.slice('type')).tap do |resource|
          attributes['id'] = "__#{ object_id }"
          temporarily_extend_new_resource(resource, attributes)
        end
      end
    end
  end
end
