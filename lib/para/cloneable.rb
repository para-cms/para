module Para
  module Cloneable
    extend ActiveSupport::Concern

    included do
      class_attribute :cloneable_associations
    end

    module ClassMethods
      def acts_as_cloneable(*args)
        @cloneable = true
        self.cloneable_associations = args
      end

      def cloneable?
        @cloneable ||= false
      end
    end
  end
end
