module Para
  module Ext
    module Cancan
      module ControllerResource
        extend ActiveSupport::Concern

        included do
          alias_method_chain :assign_attributes, :parent_missing_management
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
      end
    end
  end
end
