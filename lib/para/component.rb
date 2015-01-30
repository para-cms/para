module Para
  module Component
    def self.registered_components
      @registered_components ||= {}
    end

    def self.registered_component?(model_name)
      registered_components.any? do |name, component|
        component.name == model_name
      end
    end
  end
end

# Require models
require 'para/component/base'
require 'para/component/page'
require 'para/component/page_category'
require 'para/component/resource'
require 'para/component/crud'
require 'para/component/singleton_resource'
