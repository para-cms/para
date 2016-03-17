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
        as, controller, endpoint = component_informations_from(
          component_name, options
        )

        get endpoint => "#{ controller }#show", as: as
        scope(endpoint, as: component_name, &block) if block
      end

      def crud_component(component_name, options = {}, &block)
        as, controller, endpoint = component_informations_from(
          component_name, options
        )

        controller = [component_name.to_s.singularize, 'resources'].join('_')

        scope endpoint, as: as do
          resources :resources, controller: controller do
            scope options[:scope] do
              collection do
                patch :order
                patch :tree
                get :export
                post :import
              end

              member do
                post :clone
              end

              instance_eval(&block) if block
            end
          end
        end
      end

      def singleton_resource_component(component_name, options = {}, &block)
        as, _, endpoint = component_informations_from(
          component_name, options
        )

        controller = [component_name, 'resources'].join('_')

        scope endpoint, as: as do
          resource :resource, controller: controller, only: [:show, :create, :update]
        end
      end

      private

      def draw_plugin_routes(identifier)
        routes = [
          Para::Plugins.module_name_for(identifier),
          'Routes'
        ].join('::').constantize

        routes.new(self).draw
      end

      def component_informations_from(component_name, options)
        path = options.fetch(:path, component_name.to_s)
        as = options.fetch(:as, component_name)
        controller = options.fetch(:controller, "#{ component_name }_component")
        endpoint = "#{ path }/:component_id"

        [as, controller, endpoint]
      end
    end
  end
end
