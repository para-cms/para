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

        component_path_for(method, component)
      end

      def component_relation_path(component, relation, resource = nil, action = :index)
        if [:index, :show, :create, :update, :destroy].include?(action)
          action = nil
        end

        if resource.present? && resource.new_record?
          relation_path = relation.to_s.underscore.pluralize
        else
          relation_path = relation.to_s.underscore.singularize
        end

        method = [
          action,
          'admin',
          component.class.component_name,
          relation_path,
          'path'
        ].compact.join('_')

        component_path_for(method, component, resource)
      end

      def component_path_for(method, *args)
        [self, main_app, para].each do |context|
          if context.respond_to?(method) && (path = context.send(method, *args))
            return path
          # Rescue nil because of a Rails bug where respond_to? returns true
          # but method is undefined
          end rescue nil
        end
        # No route found in any context, return `nil`
        nil
      end

      def searchable_attributes(attributes)
        attributes.select do |attr|
          [:string, :text].include?(attr.type.to_sym)
        end.map(&:name).join('_or_')
      end

      def find_table_partial_for(relation)
        if lookup_context.find_all("admin/#{relation}/_table").any?
          "admin/#{relation}/table"
        else
          'para/admin/resources/table'
        end
      end

      def attribute_field_mappings_for(component, relation)
        model = relation_klass_for(component, relation)
        Para::AttributeFieldMappings.new(model).fields
      end

      def relation_klass_for(component, relation)
        component.class.reflections[relation.to_sym].klass
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
