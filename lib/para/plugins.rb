module Para
  module Plugins
    extend ActiveSupport::Autoload

    def self.module_name_for(identifier)
      ['Para', identifier.to_s.camelize].join('::')
    end
  end
end

require 'para/plugins/set'
require 'para/plugins/routes'
