module Para
  module Sti
    module RootModel
      extend ActiveSupport::Concern

      included do
        Rails.logger.warn '[Warning] Para::Sti::RootModel is deprecated and ' \
          'has no effect at all on your model. Please use the :nested_many ' \
          'input :subclasses option to provided a list of available ' \
          'subclasses to create.'
      end
    end
  end
end
