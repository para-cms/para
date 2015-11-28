module Para
  module AttributeField
    class Translation < AttributeField::Base
      register :translation, self

      def attribute_column_path
        [:translations, name]
      end
    end
  end
end
