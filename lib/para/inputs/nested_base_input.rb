module Para
  module Inputs
    class NestedBaseInput < SimpleForm::Inputs::Base
      GLOBAL_NESTED_FIELD_KEY = "para.nested_field.parent"

      private

      # This allows to access the parent nested field from a child nested field
      # and fetch some of its data. This is useful for deeply nested cocoon
      # fields.
      #
      def with_global_nested_field(&block)
        @parent_nested_field = RequestStore.store[GLOBAL_NESTED_FIELD_KEY]
        RequestStore.store[GLOBAL_NESTED_FIELD_KEY] = self

        block.call.tap do
          RequestStore.store[GLOBAL_NESTED_FIELD_KEY] = @parent_nested_field
        end
      end

      def parent_nested_field
        @parent_nested_field || RequestStore.store[GLOBAL_NESTED_FIELD_KEY]
      end
    end
  end
end
