module Para
  module Component
    module SingletonResourceDecorator
      include Para::Component::BaseDecorator

      def relation_path(controller_or_resource, options = {})
        polymorphic_path([:admin, self, :singleton_resource].compact, options)
      end
    end
  end
end
