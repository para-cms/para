module Para
  module Component
    module BaseDecorator
      include Rails.application.routes.mounted_helpers
      include ActionDispatch::Routing::PolymorphicRoutes

      def path(options = {})
        find_path([:admin, self], options)
      end

      def relation_path(controller_or_resource, options = {})
        if Hash === controller_or_resource
          options = controller_or_resource
          controller_or_resource = nil
        end

        components = [:admin, self, controller_or_resource].compact
        find_path(components, options)
      end

      private

      # Try to find a polymorphic path for the given arguments
      #
      # If no route exist, we try all the existing engines too
      # This is quite dirty but for now should work as desired
      # The only problem is if we have engines that declare the same routes
      #
      def find_path(path, options)
        safe_polymorphic_path(path, options).tap do |result|
          raise result.class, result.message if Exception === result
        end
      end

      def safe_polymorphic_path(path, options)
        polymorphic_path(path, options)
      rescue => exception
        exception
      end
    end
  end
end
