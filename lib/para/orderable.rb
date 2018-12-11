module Para
  module Orderable
    extend ActiveSupport::Concern

    included do
      scope :ordered, -> { order("#{ table_name }.position ASC") }

      before_create :orderable_assign_position
      after_commit  :reprocess_ordering
      after_destroy :reprocess_ordering
    end

    private

    def orderable_assign_position
      return if attribute_present?(:position)

      last_resource = orderable_scope
        .where.not(position: nil)
        .select(:position)
        .first

      self.position = if last_resource && last_resource.position
        last_resource.position + 1
      else
        0
      end
    end

    # Unfragment existing resources positions
    #
    def reprocess_ordering
      orderable_scope.each_with_index do |resource, index|
        resource.update_column(:position, index)
      end
    end

    def orderable_scope
      if (parent = _orderable_options[:parent]) && (as = _orderable_options[:as])
        try(parent).try(as).try(:ordered) || self.class.none
      else
        self.class.unscoped.ordered
      end
    end
  end

  module ActiveRecordOrderableMixin
    extend ActiveSupport::Concern

    included do
      class_attribute :orderable, :_orderable_options
    end

    module ClassMethods
      def acts_as_orderable(options = {})
        return if orderable?

        unless (
          ( options[:parent] &&  options[:as]) ||
          (!options[:parent] && !options[:as])
        )
          raise "You need to either pass :parent and :as options to the " \
                "acts_as_orderable macro, or no options at all."
        end

        self.orderable = true
        self._orderable_options = options
        include Para::Orderable
      end

      def orderable?
        !!orderable
      end
    end
  end
end
