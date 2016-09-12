# Allows constraining routing to components that explicitly declares to use a
# given controller to manage their resources.
#
# It's mainly used to allow users to override the default controller for the
# resources of a given Crud or Form components without having to
# subclass the component and declare all the routes again
#
module Para
  module Routing
    class ComponentControllerConstraint
      attr_reader :controller

      def initialize(controller)
        @controller = controller.to_sym
      end

      def matches?(request)
        component = component_for(request.params[:component_id])
        return false unless component
        component.controller.to_sym == controller
      end

      private

      def component_for(component_slug)
        self.class.components[component_slug] ||= Para::Component::Base.find_by_slug(component_slug)
      end

      # Request based components cache
      #
      def self.components
        RequestStore.store['para.components_by_id'] ||= {}
      end
    end
  end
end
