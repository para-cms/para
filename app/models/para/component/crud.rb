module Para
  module Component
    class Crud < Para::Component::Resource
      register :crud, self

      configurable_on :model_type, as: :selectize, collection: :available_models
      configurable_on :namespaced, as: :boolean, collection: [true, false],
                      wrapper: :horizontal_radio_and_checkboxes

      has_many :component_resources, class_name: 'Para::ComponentResource',
               foreign_key: :component_id, autosave: true

      def namespaced?
        !!namespaced
      end

      def resources
        namespaced? ? namespaced_resources : model.all
      end

      def add_resource(resource)
        component_resources.create(resource: resource)
      end

      def remove_resource(resource)
        component_resources.where(resource: resource).first.destroy
      end

      private

      def namespaced_resources
        model.joins(
          "INNER JOIN para_component_resources ON " +
          "para_component_resources.resource_id = #{ model_table_name }.id"
        ).where(
          para_component_resources: { component_id: id }
        )
      end
    end
  end
end
