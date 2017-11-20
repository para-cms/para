module Para
  module Component
    module History
      extend ActiveSupport::Concern

      included do
        configurable_on :history
      end

      def history?
        history.present? && history == 'true'
      end
    end
  end
end
