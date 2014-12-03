require 'devise'
require 'paperclip'
require 'simple_form'
require 'simple_form_extension'
require 'active_decorator'
require 'friendly_id'
require 'haml-rails'
require 'truncate_html'
require 'cocoon'
require 'cancan'
require 'request_store'

require 'sass-rails'
require 'selectize-rails'
require 'bootstrap-sass'
require 'compass-rails'
require 'font-awesome-rails'

require 'rails/routing_mapper'
require 'rails/relation_length_validator'

require 'para/errors'
require 'para/config'
require 'para/model_field_parsers'
require 'para/attribute_field_mappings'
require 'para/inputs'
require 'para/orderable'
require 'para/form_builder'
require 'para/markup'
require 'para/engine'

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
