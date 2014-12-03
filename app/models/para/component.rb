module Para
  module Component
    def self.registered_components
      @registered_components ||= {}
    end

    def self.registered_component?(model)
      registered_components.any? do |name, component|
        component.name == model
      end
    end
  end
end

require 'para/component/base'
require 'para/component/page'
require 'para/component/page_category'
require 'para/component/crud'
