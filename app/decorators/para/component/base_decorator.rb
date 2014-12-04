module Para
  module Component
    module BaseDecorator
      include Rails.application.routes.mounted_helpers
      include ActionDispatch::Routing::PolymorphicRoutes

      def path(options = {})
        find_path([:admin, self], options)
      end

      def relation_path(controller_or_resource, options = {})
        find_path([:admin, self, controller_or_resource], options)
      end

      private

      # Try to find a polymorphic path for the given arguments
      #
      # If no route exist, we try all the existing engines too
      # This is quite dirty but for now should work as desired
      # The only problem is if we have engines that declare the same routes
      #
      def find_path(path, options)
        polymorphic_path(path, options)
      rescue NoMethodError, NameError => original_error
        mounted_proxy_methods.each do |proxy_method|
          begin
            proxy = send(proxy_method)
            return polymorphic_path(([proxy] + path), options)
          rescue NoMethodError, NameError => e
            next
          end
        end

        raise original_error
      end

      def mounted_proxy_methods
        @mounted_proxy_methods ||= begin
          routes = Rails.application.routes
          routes.mounted_helpers.instance_methods.select do |name|
            /^[^_]/ =~ name
          end
        end
      end
    end
  end
end
