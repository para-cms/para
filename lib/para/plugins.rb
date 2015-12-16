module Para
  module Plugins
    extend ActiveSupport::Autoload

    autoload :Routes

    def self.module_name_for(identifier)
      ['Para', identifier.to_s.camelize].join('::')
    end
  end
end
