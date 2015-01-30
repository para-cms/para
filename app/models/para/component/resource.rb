module Para
  module Component
    class Resource < Para::Component::Base
      def model
        @model ||= model_type.presence && model_type.constantize
      end

      def available_models
        Rails.application.eager_load!

        ActiveRecord::Base.descendants.map(&:name).sort.reject do |name|
          next true if name == 'ActiveRecord::SchemaMigration'
          next true if name.match(/^HABTM_/)
          next true if name.match(/Component$/)
          next true if name.match(/^Para::Component/)
          next true if excluded_models.include?(name)

          false
        end
      end

      private

      def excluded_models
        %w(FriendlyId::Slug)
      end
    end
  end
end
