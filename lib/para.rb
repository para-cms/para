require 'haml-rails'
require 'sass-rails'
require 'simple_form'
require 'simple_form_extension'
require 'cocoon'
require 'devise'
require 'cancan'
require 'request_store'
require 'friendly_id'
require 'selectize-rails'
require 'bootstrap-sass'
require 'compass-rails'
require 'font-awesome-rails'

require 'rails/routing_mapper'
require 'rails/relation_length_validator'
require 'para/attribute_field_mappings'
require 'para/engine'
require 'para/config'
require 'para/inputs'
require 'para/orderable'
require 'para/form_builder'

module Para
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Config
    autoload :Component
  end

  def self.config(&block)
    if block
      block.call(Para::Config)
    else
      Para::Config
    end
  end

  def self.store
    RequestStore.store
  end
end
