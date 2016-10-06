# Allows constraining routing to components that explicitly declares to use a
# given component to manage their resources.
#
# It's mainly used to allow users to override the default component for the
# resources of a given Crud or Form components without having to
# subclass the component and declare all the routes again
#
module Para
  module Routing
    class ComponentNameConstraint
      attr_reader :component

      def initialize(component)
        @component = component.to_s
      end

      def matches?(request)
        component == request.params[:component]
      end
    end
  end
end
