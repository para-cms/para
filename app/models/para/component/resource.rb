module Para
  module Component
    class Resource < Para::Component::Base
      class ModelNotFound < NameError; end

      def model
        @model ||= model_type.presence && model_type.constantize
      rescue NameError
        raise ModelNotFound,
          "The model #{ model_type } was not found. You may need to set " +
          "the :model_type option in your component definition in the " +
          "config/components.rb file. If no component should actually " +
          "reference this model, you may need to run the " +
          "`rake para:components:clean` task to clean up your components index."
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
