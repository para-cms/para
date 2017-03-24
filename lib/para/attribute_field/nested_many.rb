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

      def fetch_or_build_nested_resource_for(parent, index, attributes)
        nested_resources = parent.association(name).load_target

        if (id = attributes['id'].presence)
          nested_resources.find { |res| res.id == id.to_i }
        else
          parent.association(name).build(attributes.slice('type')).tap do |resource|
            attributes['id'] = "__#{ index }"
            resource.define_singleton_method(:id) { attributes['id'] }
          end
        end
      end
    end
  end
end
