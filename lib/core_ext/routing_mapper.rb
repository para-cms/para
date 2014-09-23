module ActionDispatch::Routing
  class Mapper
    def component(component_name, options = {}, &block)
      path = options.fetch(:path, component_name.to_s)
      as = options.fetch(:as, component_name)
      controller = options.fetch(:controller, "#{ component_name }_component")

      endpoint = "#{ path }/:component_id"

      get endpoint => "#{ controller }#show", as: as

      scope(endpoint, as: component_name, &block) if block
    end
  end
end
