module Para
  module Component
    class Crud < Para::Component::Resource
      register :crud, self

      include Para::Component::Exportable
      include Para::Component::Importable
      include Para::Component::Subclassable

      configurable_on :model_type
      configurable_on :namespaced

      has_many :component_resources, class_name: 'Para::ComponentResource',
               foreign_key: :component_id, autosave: true, dependent: :destroy

      before_validation :ensure_model_type

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

      def update_with(attributes)
        # If no model_type is provided in the configuration file, default to
        # the singular and camelized version of the identifier, allowing to
        # create crud components without setting the :model_type option, when
        # given a conventional name
        attributes[:model_type] ||= identifier.to_s.camelize.singularize if identifier
        attributes[:controller] ||= '/para/admin/crud_resources'

        super
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

      def ensure_model_type
        self.model_type ||= identifier
      end
    end
  end
end
