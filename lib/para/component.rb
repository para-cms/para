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

    def self.config
      @config ||= Para::ComponentsConfiguration.new
    end
  end
end

# Require concerns
require 'para/component/exportable'
require 'para/component/subclassable'

# Require models
require 'para/component/base'
require 'para/component/resource'
require 'para/component/crud'
require 'para/component/singleton_resource'
require 'para/component/settings'
