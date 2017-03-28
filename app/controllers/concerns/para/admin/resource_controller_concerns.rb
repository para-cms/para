module Para
  module Admin
    module ResourceControllerConcerns
      extend ActiveSupport::Concern

      included do
        before_action :set_resource_model_from_resource
      end

      private

      def set_resource_model_from_resource
        @resource_model = resource.class if resource
      end

      def resource_model
        @resource_model ||= @component.try(:model)
      end

      def resource
        @resource ||= begin
          resource = instance_variable_get(:"@#{ resource_name }")
          # We ensure that the fetched resource is not a relation, which could
          # happen for uncountable resource names (like "news") and would make
          # code depending on the `resource` getter to fail unexpectedly
          resource unless ActiveRecord::Relation === resource
        end
      end

      def resource_name
        resource_model.model_name.singular_route_key
      end
    end
  end
end
