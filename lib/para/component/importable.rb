module Para
  module Component
    module Importable
      extend ActiveSupport::Concern

      included do
        configurable_on :importers
      end

      def importable?
        @importable ||= imports.length > 0
      end

      # TODO : Move :configuration column store to JSON instead of HStore
      # which handles more data types and will help us avoid eval here
      def imports
        @imports ||= if importers.present?
          eval(importers)
        else
          []
        end
      end
    end
  end
end
