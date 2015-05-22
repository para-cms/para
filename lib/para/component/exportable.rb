module Para
  module Component
    module Exportable
      extend ActiveSupport::Concern

      included do
        configurable_on :export
      end

      def exportable?
        @exportable ||= exports.length > 0
      end

      # TODO : Move :configuration column store to JSON instead of HStore
      # which handles more data types and will help us avoid eval here
      def exports
        @exports ||= if export.present?
          eval(export).map(&:with_indifferent_access)
        else
          []
        end
      end
    end
  end
end
