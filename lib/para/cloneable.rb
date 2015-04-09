module Para
  module Cloneable
    extend ActiveSupport::Concern

    module ClassMethods
      def para_cloneable *args
        cattr_accessor :para_cloneable_associations
        self.para_cloneable_associations = args
      end
    end
  end
end
