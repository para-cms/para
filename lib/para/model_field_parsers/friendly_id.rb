module Para
  module ModelFieldParsers
    class FriendlyId < Para::ModelFieldParsers::Base
      register :friendly_id, self

      def parse!
        key = model.friendly_id_config.slug_column

        fields_hash[key] = AttributeField::FriendlyId.new(
          model, name: key, type: 'friendly_id'
        )
      end

      def applicable?
        !!model.try(:friendly_id_config)
      end
    end
  end
end
