module Para
  module Component
    class Base < ActiveRecord::Base
      self.table_name = 'para_components'

      class_attribute :component_name

      def self.register(name, component)
        self.component_name = name
        Para::Component.registered_components[name] = component
      end

      def self.configurable_on(key, options = {})
        store_accessor(:configuration, key)
      end

      configurable_on :controller

      belongs_to :component_section, class_name: 'Para::ComponentSection'

      validates :identifier, :type, presence: true

      before_validation :ensure_slug

      scope :ordered, -> { order(position: :asc) }

      def name
        read_attribute(:name) || ::I18n.t(
          "components.component.#{ identifier }",
          default: identifier.humanize
        )
      end

      def exportable?
        false
      end

      def subclassable?
        false
      end

      def history?
        false
      end

      def self.model_name
        @model_name ||= ModelName.new(self)
      end

      def default_form_actions
        [:submit, :submit_and_edit, :submit_and_add_another, :cancel]
      end

      def to_param
        slug
      end

      # This method is used by the components configuration system to assign
      # updated attributes from the config file to the component.
      #
      # This is meant to be overriden by components that have to define specific
      # behavior, like for the Crud component
      #
      def update_with(attributes)
        assign_attributes(attributes)
      end

      private

      def ensure_slug
        self.slug = identifier.parameterize if slug.blank? || identifier_changed?
      end
    end

    class ModelName < ActiveModel::Name
      def route_key
        super.gsub(/(para_|component_|_component$)/, '')
      end

      def singular_route_key
        super.gsub(/(para_|component_|_component$)/, '')
      end
    end
  end
end
