require 'haml-rails'
require 'sass-rails'
require 'simple_form'
require 'simple_form_extension'
require 'devise'
require 'cancan'
require 'friendly_id'
require 'bootstrap-sass'
require 'font-awesome-rails'

require 'core_ext/routing_mapper'
require 'para/attribute_field_mappings'
require 'para/engine'
require 'para/config'

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
end
