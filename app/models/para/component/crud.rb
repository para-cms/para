module Para
  module Component
    class Crud < Para::Component::Resource
      register :crud, self

      include Para::Component::Exportable
      include Para::Component::Subclassable

      configurable_on :model_type
      configurable_on :namespaced

      has_many :component_resources, class_name: 'Para::ComponentResource',
               foreign_key: :component_id, autosave: true

      def namespaced?
        case namespaced
        when 'true' then true
        else false
        end
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
