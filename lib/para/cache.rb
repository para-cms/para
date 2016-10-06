module Para
  module Cache
    extend ActiveSupport::Autoload

    autoload :DatabaseStore

    def self.table_name_prefix
      'para_cache_'
    end
  end
end
