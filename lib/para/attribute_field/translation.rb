module Para
  module AttributeField
    class Translation < AttributeField::Base
      def attribute_column_path
        [:translations, name]
      end
    end
  end
end
