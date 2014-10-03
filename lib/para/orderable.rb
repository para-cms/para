module Para
  module Orderable
    extend ActiveSupport::Concern

    included do
      scope :ordered, -> { order('position ASC') }
      before_create :orederable_assign_position
    end

    def orederable_assign_position
      last_resource = self.class.order('position DESC')
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
