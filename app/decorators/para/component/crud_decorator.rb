module Para
  module Component
    module CrudDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        options[:model] ||= model_singular_route_key
        find_path([:admin, self, :resources], options)
      end

      def relation_path(controller_or_resource, *nested_resources, **options)
        id_key = nested_resources.empty? ? :id : :resource_id

        if (id = extract_id_from(controller_or_resource))
          options[id_key] = id
        end

        route_key = route_key_for(options[id_key], options)
        options[:model] = model_singular_route_key

        data = [:admin, self, route_key].compact + nested_resources

        polymorphic_path(data, options)
      end

      private

      def extract_id_from(object)
        object.id if object.respond_to?(:persisted?) && object.persisted?
      end

      def route_key_for(id, options)
        if id || options[:action].presence && options[:action].to_sym == :new
          :resource
        else
          :resources
        end
      end

      def model_singular_route_key
        @model_singular_route_key ||= model.model_name.singular_route_key
      end
    end
  end
end
