module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      include Para::Helpers::AttributesMappings

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
        model = if (type = nested_attributes[:type]).present?
          nested_attributes[:type].try(:constantize)
        else
          reflection.klass
        end

        mappings = attributes_mappings_for(nested_attributes)

        AttributeFieldMappings.new(model, mappings: mappings)
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
            temporarily_extend_new_resource(resource, attributes)
          end
        end
      end

      # This method extends the current resource so its #id method returns a
      # fake id based on the given attributes, but immediately returns to its
      # standard behavior of returning nil as soon as the `#assign_attributes`
      # method is called.
      #
      # During nested attributes assignation, the id of the resource is used
      # to assign it its nested params. When it is nil, a new resource is
      # created, but since we already need our resource to be created at the
      # time we parse the input params, we fake the presence of an id while the
      # nested attributes assignation is running, and remove that behavior as
      # soon as we don't need it anymore.
      #
      def temporarily_extend_new_resource(resource, attributes)
        resource.instance_variable_set(:@_waiting_for_attributes_assignation, true)

        resource.define_singleton_method(:assign_attributes) do |*args|
          super(*args).tap do
            @_waiting_for_attributes_assignation = false
          end
        end

        resource.define_singleton_method(:id) do
          @_waiting_for_attributes_assignation ? attributes['id'] : read_attribute(:id)
        end
      end
    end
  end
end
