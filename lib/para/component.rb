module Para
  module Component
    def self.registered_components
      @registered_components ||= {}
    end

    def self.registered_component?(identifier)
      registered_components.any? do |component_identifier, _|
        component_identifier == identifier
      end
    end

    def self.config
      @config ||= Para::ComponentsConfiguration.new
    end
  end
end

# Require concerns
require 'para/component/exportable'
require 'para/component/importable'
require 'para/component/subclassable'

# Require models
require 'para/component/base'
require 'para/component/resource'
require 'para/component/crud'
require 'para/component/form'
require 'para/component/settings'
