module Para
  module Component
    module Exportable
      extend ActiveSupport::Concern

      included do
        configurable_on :exporters

        define_method(:exporters) do
          @exporters ||= if (exporters = configuration['exporters'].presence)
            eval(exporters).map(&:constantize)
          else
            []
          end
        end
      end

      def exportable?
        @exportable ||= exporters.length > 0
      end
    end
  end
end
