module Para
  module Component
    module Subclassable
      extend ActiveSupport::Concern

      included do
        configurable_on :subclasses
      end

      def subclassable?
        @subclassable ||= subclass_names.length > 0
      end

      def subclassable_with?(class_name)
        subclassable? && class_name.in?(subclass_names)
      end

      def subclass_names
        @subclass_names ||= if subclasses.present?
          eval(subclasses)
        else
          []
        end
      end
    end
  end
end
