module Para
  module Tree
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

  module ActiveRecordTreeMixin
    extend ActiveSupport::Concern

    included do
      class_attribute :tree
    end

    module ClassMethods
      def acts_as_tree
        return if tree?

        self.tree = true
        include Para::Tree
      end

      def tree?
        !!tree
      end
    end
  end
end
