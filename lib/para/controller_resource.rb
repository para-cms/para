module Para
  class ControllerResource < CanCan::ControllerResource
    # Todo : Document why this extension was added ?
    def assign_attributes(resource)
      if @options[:singleton] && parent_resource && resource.respond_to?(:"#{ parent_name }=")
        resource.send(:"#{ parent_name }=", parent_resource)
      end

      initial_attributes.each do |attr_name, value|
        resource.send(:"#{ attr_name }=", value)
      end

      resource
    end

    # Remove automatic params assignation and let our controllers do it
    # manually, letting our attribute fields to parse the params with a
    # reference to the current resource.
    #
    # Before this override, some attribute fields raised during #parse_input
    # because of the controller resource that was missing at the time it
    # was called (during the resource instanciation ...)
    #
    def build_resource
      resource = resource_base.new

      unless @options[:bypass_params_assignation]
        resource.assign_attributes(resource_params || {})
      end

      assign_attributes(resource)
    end
  end
end
