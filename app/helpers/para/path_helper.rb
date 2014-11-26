module Para
  module PathHelper
    def component_path(component, action = :index)
      action = action_path_name_for(action)

      method = build_route_method_from(component, action)
      component_path_for(method, component)
    end

    def component_relation_path(component, relation, resource = nil, action = :index, options = {})
      action = action_path_name_for(action)

      relation_path = relation.to_s.camelize.demodulize.underscore

      relation_path = if resource.present? && resource.new_record?
        relation_path.pluralize
      else
        relation_path.singularize
      end

      method = build_route_method_from(component, action, relation_path)

      component_path_for(method, component, resource, options)
    end

    private

    def action_path_name_for(action)
      if [:index, :show, :create, :update, :destroy].include?(action)
        nil
      else
        action
      end
    end

    def build_route_method_from(component, action, *args)
      [
        action,
        'admin',
        component.class.component_name,
        *args,
        'path'
      ].compact.join('_')
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
  end
end
