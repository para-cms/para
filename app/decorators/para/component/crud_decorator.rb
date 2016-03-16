module Para
  module Component
    module CrudDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        find_path([:admin, self, :resources], options)
      end

      def relation_path(controller_or_resource, options = {})
        if (id = extract_id_from(controller_or_resource))
          options[:id] = id
        end

        route_key = route_key_for(options[:id], options)
        options[:model] = model.model_name.singular_route_key

        polymorphic_path([:admin, self, route_key].compact, options)
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
    end
  end
end
