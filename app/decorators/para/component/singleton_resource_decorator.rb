module Para
  module Component
    module SingletonResourceDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        find_path([:admin, self, :resource], options)
      end

      def relation_path(controller_or_resource, *nested_resources, **options)
        nested_resources << :resource if nested_resources.empty?
        data = [:admin, self, *nested_resources]
        polymorphic_path(data, options)
      end
    end
  end
end
