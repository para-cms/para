module Para
  module Component
    def self.registered_components
      @registered_components ||= {}
    end

    class Base < ActiveRecord::Base
      self.table_name = 'para_components'

      class_attribute :component_name

      def self.register(name, component)
        self.component_name = name
        Para::Component.registered_components[name] = component
      end

      extend FriendlyId
      friendly_id :name, use: [:slugged, :finders, :history]

      validates :name, :type, presence: true

      scope :ordered, -> { order('position ASC') }

      def self.model_name
        @model_name ||= CustomName.new(self)
      end

      def should_generate_new_friendly_id?
        slug.blank? || name_changed?
      end
    end
  end
end

class CustomName < ActiveModel::Name
  def route_key
    super.gsub(/(para_|component_)/, '')
  end

  def singular_route_key
    super.gsub(/(para_|component_)/, '')
  end
end

require 'para/component/page'
require 'para/component/page_category'
