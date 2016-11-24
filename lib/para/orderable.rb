module Para
  module Orderable
    extend ActiveSupport::Concern

    included do
      scope :ordered, -> { order("#{ table_name }.position ASC") }
      before_create :orderable_assign_position
    end

    def orderable_assign_position
      return if attribute_present?(:position)

      last_resource = self.class.unscoped
        .ordered
        .where.not(position: nil)
        .select(:position)
        .first

      self.position = if last_resource && last_resource.position
        last_resource.position + 1
      else
        0
      end
    end
  end

  module ActiveRecordOrderableMixin
    extend ActiveSupport::Concern

    included do
      class_attribute :orderable
    end

    module ClassMethods
      def acts_as_orderable
        return if orderable?

        self.orderable = true
        include Para::Orderable
      end

      def orderable?
        !!orderable
      end
    end
  end
end
