module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      include Para::Helpers::AttributesMappings
      include Para::AttributeField::NestedField

      register :nested_many, self

      def parse_input(params, resource)
        if (nested_attributes = params[nested_attributes_key])
          nested_attributes.each do |index, attributes|
            nested_resource = fetch_or_build_nested_resource_for(resource, index, attributes)
            mappings = nested_model_mappings(attributes, nested_resource)

            mappings.fields.each do |field|
              field.parse_input(attributes, nested_resource)
            end

            params[nested_attributes_key][index] = attributes
          end
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
      def fetch_or_build_nested_resource_for(parent, index, attributes)
        nested_resources = parent.association(name).load_target

        if (id = attributes['id'].presence)
          nested_resources.find { |res| res.id == id.to_i }
        else
          parent.association(name).build(attributes.slice('type')).tap do |resource|
            attributes['id'] = "__#{ index }"
            temporarily_extend_new_resource(resource, attributes)
          end
        end
      end
    end
  end
end
