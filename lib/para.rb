require 'rails-i18n'
require 'devise'
require 'paperclip'
require 'simple_form'
require 'simple_form_extension'
require 'active_decorator'
require 'haml-rails'
require 'truncate_html'
require 'cocoon'
require 'cancan'
require 'request_store'
require 'spreadsheet'
require 'roo'
require 'roo-xls'
require 'activejob-status'
require 'kaminari'
require 'ransack'
require 'friendly_id'
require 'deep_cloneable'
require 'closure_tree'
require 'friendly_id'

require 'jquery-rails'
require 'turbolinks'
require 'sass-rails'
require 'selectize-rails'
require 'bootstrap-sass'
require 'compass-rails'
require 'font-awesome-rails'

require 'vertebra'

require 'rails/routing_mapper'
require 'rails/relation_length_validator'

require 'para/log_config'
require 'para/postgres_extensions_checker'

module Para
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Config
    autoload :Component
    autoload :ControllerResource
    autoload :Generators
    autoload :Helpers
    autoload :SimpleFormConfig
    autoload :Routing
    autoload :Routes
    autoload :Breadcrumbs
    autoload :Cache
    autoload :Logging
    autoload :IframeTransport
  end

  def self.config(&block)
    if block
      block.call(Para::Config)
    else
      Para::Config
    end
  end

  def self.components
    Para::Component.config
  end

  def self.store
    RequestStore.store
  end

  def self.table_name_prefix
    'para_'
  end
end

require 'para/ext'
require 'para/errors'
require 'para/plugins'
require 'para/config'
require 'para/model_field_parsers'
require 'para/attribute_field'
require 'para/attribute_field_mappings'
require 'para/inputs'
require 'para/cloneable'
require 'para/orderable'
require 'para/form_builder'
require 'para/markup'
require 'para/engine'
require 'para/components_configuration'
require 'para/job'
require 'para/exporter'
require 'para/importer'
require 'para/sti'
require 'para/page'
require 'para/search'
