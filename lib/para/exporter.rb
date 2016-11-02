module Para
  module Exporter
    extend ActiveSupport::Autoload

    autoload :Base
    autoload :Table
    autoload :Csv
    autoload :Xls
  end
end
