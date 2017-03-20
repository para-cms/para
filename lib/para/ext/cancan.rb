module Para
  module Ext
    module Cancan
      module ControllerResource
        extend ActiveSupport::Concern

        included do
          alias_method_chain :assign_attributes, :parent_missing_management
          alias_method_chain :params_method, :bypass_assignation
        end

        # Todo : Document why this extension was added ?
        def assign_attributes_with_parent_missing_management(resource)
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
        def params_method_with_bypass_assignation
          return if @options[:bypass_params_assignation]
          params_method_without_bypass_assignation
        end
      end
    end
  end
end
