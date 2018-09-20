module Para
  module AttributeField
    module NestedField
      def nested_model_mappings(nested_attributes, resource)
        model = if resource
          resource.class
        elsif (type = nested_attributes[:type]).present?
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
          @_waiting_for_attributes_assignation = false
          super(*args)
        end

        resource.define_singleton_method(:id) do
          @_waiting_for_attributes_assignation ? attributes['id'] : read_attribute(:id)
        end
      end
    end
  end
end
