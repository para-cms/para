module Para
  module Component
    class Form < Para::Component::Resource
      register :form, self

      configurable_on :model_type

      has_one :component_resource, class_name: 'Para::ComponentResource',
              foreign_key: :component_id, autosave: true, dependent: :destroy

      def resource
        build_component_resource(resource: model.new) unless component_resource
        component_resource.resource ||= model.new
      end

      def resource=(value)
        build_component_resource(resource: value) unless component_resource
      end

      def default_form_actions
        [:submit]
      end

      def update_with(attributes)
        # If no model_type is provided in the configuration file, default to
        # the camelized version of the identifier, allowing to create
        # form components without setting the :model_type option,
        # when given a conventional name
        attributes[:model_type] ||= identifier.to_s.camelize.singularize if identifier
        attributes[:controller] ||= '/para/admin/form_resources'

        super
      end
    end
  end
end
