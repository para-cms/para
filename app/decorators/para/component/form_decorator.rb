module Para
  module Component
    module FormDecorator
      include Para::Component::BaseDecorator

      def path(namespace: :resource, **options)
        find_path([:admin, self, namespace], options)
      end

      def relation_path(controller_or_resource, *nested_resources, **options)
        nested = nested_resources.any?

        if Hash === controller_or_resource
          options = controller_or_resource
        end

        options[:action] = action_option_for(options, nested: nested)
        data = [:admin, self, :resource, *nested_resources]

        find_path(data, options)
      end

      def page_container_class
        history? ? 'col-md-8' : super
      end

      private

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
