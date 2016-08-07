module Para
  module Component
    class Resource < Para::Component::Base
      def model
        @model ||= model_type.presence && model_type.constantize
      end

      def model_table_name
        model && model.table_name
      end

      private

      def excluded_models
        %w(FriendlyId::Slug)
      end
    end
  end
end
