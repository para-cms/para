module Para
  module Admin
    module ResourcesHelper
      def resource_form_path(resource)
        if resource.new_record?
          resource_path(resource, :index)
        else
          resource_path(resource, :show)
        end
      end

      def resource_path(resource, action =:index)
        resource = resource.kind_of?(Class) ? resource.new : resource
        route_key = resource.class.model_name.route_key

        component_path = @component && @component.to_param
        id = resource.id

        if [:index, :show, :create, :update, :destroy].include?(action)
          action = nil
        end

        ["", "admin", component_path, route_key, id, action].compact.join('/')
      end

      def resource_title_for(resource)
        resource.try(:title) || resource.try(:name) ||
        t('para.form.shared.edit.title', model: resource.class.model_name.human)
      end
    end
  end
end
