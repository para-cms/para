module Para
  module Helpers
    module ResourceName
      def resource_name(resource)
        Para.config.resource_name_methods.each do |method|
          return resource.send(method) if resource.respond_to?(method)
        end

        model_name = resource.class.model_name.human
        "#{ model_name } - #{ resource.id }"
      end
    end
  end
end
