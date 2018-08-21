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
        as, component, endpoint = component_informations_from(
          component_name, options
        )

        controller = options.fetch(:controller, "#{ component_name }_component")

        constraints Para::Routing::ComponentNameConstraint.new(component) do
          namespace :admin do
            defaults(component: component) do
              resource endpoint, controller: controller, as: as
            end

            scope(endpoint, as: component_name, defaults: { component: component }) do
              instance_eval(&block) if block
              add_extensions_for(:component)

              common_component_routes(options)
            end
          end
        end
      end

      def crud_component(component_name = nil, options = {}, &block)
        if !component_name || Hash === component_name
          options = component_name || {}
          component_name = :crud
          options[:scope] ||= ':model'
        end

        as, component, endpoint = component_informations_from(
          component_name, options
        )

        # By default, use absolute paths to para default controllers, avoiding
        # namespacing issues in plugins and other module namespaced scenarios
        #
        controller = options.fetch(:controller, '/para/admin/crud_resources')
        imports_controller = options.fetch(:imports_controller, '/para/admin/imports')
        exports_controller = options.fetch(:exports_controller, '/para/admin/exports')

        constraints Para::Routing::ComponentNameConstraint.new(component) do
          constraints Para::Routing::ComponentControllerConstraint.new(controller) do
            namespace :admin do
              scope(endpoint, as: as, defaults: { component: component }) do
                scope options[:scope] do
                  resources :resources, controller: controller do
                    collection do
                      patch :order
                      patch :tree
                    end

                    member do
                      post :clone
                    end

                    instance_eval(&block) if block
                    add_extensions_for(:crud_component)
                  end

                  common_component_routes(options)
                end
              end
            end
          end
        end
      end

      def form_component(component_name = nil, options = {}, &block)
        if !component_name || Hash === component_name
          options = component_name || {}
          component_name = :form
          options[:scope] ||= ':model'
        end

        as, component, endpoint = component_informations_from(
          component_name, options
        )

        controller = options.fetch(:controller, '/para/admin/form_resources')
        imports_controller = options.fetch(:imports_controller, '/para/admin/imports')
        exports_controller = options.fetch(:exports_controller, '/para/admin/exports')

        constraints Para::Routing::ComponentNameConstraint.new(component) do
          constraints Para::Routing::ComponentControllerConstraint.new(controller) do
            namespace :admin do
              scope(endpoint, as: as, defaults: { component: component }) do
                resource :resource, controller: controller, only: [:show, :create, :update] do
                  add_extensions_for(:form_component)
                end

                common_component_routes(options)
              end
            end
          end
        end
      end

      private

      def draw_plugin_routes(identifier)
        routes = [
          '',
          Para::Plugins.module_name_for(identifier),
          'Routes'
        ].join('::').constantize

        routes.new(self).draw
      # If the plugin does not define a Routes module, continue
      rescue NameError
      end

      def component_informations_from(component_name, options)
        component = options.fetch(:component, component_name.to_s)
        as = options.fetch(:as, component_name)
        endpoint = ":component/:component_id"

        [as, component, endpoint]
      end

      def add_extensions_for(type)
        Para.config.routes.routes_extensions_for(type).each do |extension|
          instance_eval(&extension)
        end
      end

      def common_component_routes(options)
        imports_controller = options.fetch(:imports_controller, '/para/admin/imports')
        exports_controller = options.fetch(:exports_controller, '/para/admin/exports')

        get 'nested-form' => 'nested_forms#show'

        scope ':importer' do
          resources :imports, controller: imports_controller
        end

        scope ':exporter' do
          resources :exports, controller: exports_controller
        end
      end
    end
  end
end
