module Para
  module Component
    class SingletonResource < Para::Component::Resource
      register :singleton_resource, self

      configurable_on :model_type, as: :selectize, collection: :available_models

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

      def model_name
        ModelName.new(self)
      end

      class ModelName < ActiveModel::Name
        def singular_route_key
          'singleton'
        end
      end
    end
  end
end
