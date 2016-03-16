module Para
  module Component
    module SingletonResourceDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        find_path([:admin, self], options)
      end

      def relation_path(controller_or_resource, options = {})
        path
      end
    end
  end
end
