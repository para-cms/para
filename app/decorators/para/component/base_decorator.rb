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
        if (result = safe_polymorphic_path(path, options))
          result
        else
          mounted_proxy_methods.each do |proxy_method|
            begin
              proxy = send(proxy_method)
              return polymorphic_path(([proxy] + path), options)
            rescue NoMethodError, NameError => e
              next
            end
          end

          raise "No component path found for : #{ path.inspect }, " +
                "with options : #{ options.inspect }"
        end
      end

      def safe_polymorphic_path(*args)
        polymorphic_path(*args)
      rescue NoMethodError, NameError
        nil
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
