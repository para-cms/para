module Para
  module Component
    module BaseDecorator
      include ActionDispatch::Routing::PolymorphicRoutes

      def relation_path(controller_or_resource, options = {})
        polymorphic_path([:admin, self, controller_or_resource], options)
      end
    end
  end
end
