module Para
  module AttributeField
    class NestedManyField < AttributeField::HasManyField
      def parse_input(params)
        # override HasManyField doing nothing
      end
    end
  end
end
