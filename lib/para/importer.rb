module Para
  module Importer
    def self.model_importer_name(model_name)
      [model_name.to_s.pluralize, 'importer'].join
    end
  end
end

require 'para/importer/base'

