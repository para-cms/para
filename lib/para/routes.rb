module Para
  class Routes
    class_attribute :routes_extensions

    attr_reader :router

    def initialize(router)
      @router = router
    end

    def draw(mount_location = '/', &block)
      router.instance_eval do
        scope mount_location do
          scope module: :para do
            namespace :admin do
              get '/' => 'main#index'
            end

            # Components are namespaced into :admin in their respective methods
            crud_component
            singleton_resource_component
            component :settings
          end

          block.call if block
        end
      end
    end

    def self.extend_routes_for(component_type, &block)
      extensions = routes_extensions_for(component_type)
      extensions << block
    end

    def self.routes_extensions_for(component_type)
      self.routes_extensions ||= {}
      self.routes_extensions[component_type] ||= []
    end
  end
end
