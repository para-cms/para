module ActionDispatch
  module Routing
    class Mapper
      def para_at(mount_location, &block)
        Para::Routes.new(self).draw(mount_location, &block)

        Para::Config.plugins.each do |plugin|
          draw_plugin_routes(plugin)
        end
      end

      def para_plugin(plugin_name)
        routes = ['', plugin_name.to_s.camelize, 'Routes'].join('::').constantize
        routes.new(self).draw
      end

      def component(component_name, options = {}, &block)
        path = options.fetch(:path, component_name.to_s)
        as = options.fetch(:as, component_name)
        controller = options.fetch(:controller, "#{ component_name }_component")

        endpoint = "#{ path }/:component_id"

        get endpoint => "#{ controller }#show", as: as
        delete endpoint => "#{ controller }#destroy", as: "destroy_#{as}"

        scope(endpoint, as: component_name, &block) if block
      end

      private

      def draw_plugin_routes(identifier)
        routes = [
          Para::Plugins.module_name_for(identifier),
          'Routes'
        ].join('::').constantize

        routes.new(self).draw
      end
    end
  end
end
