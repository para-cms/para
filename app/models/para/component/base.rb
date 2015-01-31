module Para
  module Component
    class Base < ActiveRecord::Base
      self.table_name = 'para_components'

      class_attribute :component_name, :configurable_attributes

      def self.register(name, component)
        self.component_name = name
        Para::Component.registered_components[name] = component
      end

      extend FriendlyId
      friendly_id :name, use: [:slugged, :finders, :history]

      validates :name, :type, presence: true

      belongs_to :component_section, class_name: 'Para::ComponentSection'

      scope :ordered, -> { order('position ASC') }

      def self.model_name
        @model_name ||= ModelName.new(self)
      end

      def self.configurable_on(key, options = {})
        store_accessor(:configuration, key)
        configurable_attributes[key] = options
      end

      def self.configurable?
        configurable_attributes.length > 0
      end

      def self.configurable_attributes
        @configurable_attributes ||= {}
      end

      def should_generate_new_friendly_id?
        slug.blank? || name_changed?
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
