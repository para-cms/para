module Para
  module Admin
    module BaseHelper
      def component_path(component, action = :index)
        if [:index, :show, :create, :update, :destroy].include?(action)
          action = nil
        end

        method = [
          action,
          'admin',
          component.class.component_name,
          'path'
        ].compact.join('_')

        if respond_to?(method)
          send(method, component)
        elsif main_app.respond_to?(method)
          main_app.send(method, component)
        end
      end

      def component_relation_path(component, relation, resource = nil, action = :index)
        if [:index, :show, :create, :update, :destroy].include?(action)
          action = nil
        end

        method = [
          action,
          'admin',
          component.class.component_name,
          relation.to_s.singularize,
          'path'
        ].compact.join('_')

        if respond_to?(method)
          send(method, component, resource)
        elsif main_app.respond_to?(method)
          main_app.send(method, component, resource)
        end
      end

      def editable_attributes_for(resource)
        model = resource.is_a?(Class) ? resource : resource.class

        uneditable_attributes = [
          "id", "component_id", "created_at", "updated_at"
        ]

        model.columns.each_with_object([]) do |column, attributes|
          name = column.name
          attributes << name unless uneditable_attributes.include?(name)
        end
      end

      def registered_components_options
        Para::Component.registered_components.keys.map do |identifier|
          [
            t("para.component.#{ identifier }.name", default: identifier.to_s.humanize),
            identifier
          ]
        end
      end

      def flash_message(type, resource = nil)
        key = "#{ flash_shared_key }.#{ params[:action] }.#{ type }"

        translation = if resource
          I18n.t(key, model: resource.class.model_name.human)
        else
          I18n.t(key)
        end

        flash[type] = translation
      end

      def flash_shared_key
        'para.flash.shared'
      end
    end
  end
end
