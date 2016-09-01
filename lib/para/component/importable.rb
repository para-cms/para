module Para
  module Component
    module Importable
      extend ActiveSupport::Concern

      included do
        configurable_on :importers
      end

      def importable?
        @importable ||= importers.length > 0
      end

      # TODO : Move :configuration column store to JSON instead of HStore
      # which handles more data types and will help us avoid eval here
      def importers
        @importers ||= if (importers = configuration['importers'].presence)
          eval(importers).map(&:constantize)
        else
          []
        end
      end
    end
  end
end
