module Para
  module Component
    module BaseDecorator
      include Rails.application.routes.mounted_helpers
      include ActionDispatch::Routing::PolymorphicRoutes

      def path(namespace: nil, **options)
        find_path([:admin, self, namespace].compact, options)
      end

      def relation_path(controller_or_resource, *nested_resources, **options)
        nested = nested_resources.any?

        if controller_or_resource.is_a?(Hash)
          options = controller_or_resource
          controller_or_resource = nil
        end

        controller_or_resource = nil if controller_or_resource.is_a?(ActiveRecord::Base)

        options[:action] = action_option_for(options, nested: nested)
        components = [:admin, self, controller_or_resource, *nested_resources].compact

        find_path(components, options)
      end

      def page_container_class
        'col-xs-12'
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
          raise result if result.is_a?(Exception)
        end
      end

      def safe_polymorphic_path(path, options)
        polymorphic_path(path, options)
      rescue => exception
        exception
      end

      def action_option_for(options, nested: false)
        if !nested && options[:action].try(:to_sym) == :show
          nil
        else
          options[:action]
        end
      end
    end
  end
end
