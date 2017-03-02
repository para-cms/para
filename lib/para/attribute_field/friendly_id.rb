module Para
  module AttributeField
    class FriendlyId < Base
      register :friendly_id, self

      # Set empty string as nil to allow default friendly id methods to
      # generate the slug when the field is empty
      def parse_input(params)
        params[slug_column] = nil if slug_column && params[slug_column] == ''
      end

      private

      def slug_column
        model.try(:friendly_id_config).try(:slug_column)
      end
    end
  end
end
