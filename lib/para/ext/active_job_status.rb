module Para
  module Ext
    module ActiveJob
      module StatusMixin
        extend ActiveSupport::Concern

        included do
          delegate :failed?, to: :status_inquiry
        end
      end
    end
  end
end
