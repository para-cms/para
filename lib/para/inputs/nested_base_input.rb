module Para
  module Inputs
    class NestedBaseInput < SimpleForm::Inputs::Base
      GLOBAL_NESTED_FIELD_KEY = "para.nested_field.parent"

      private

      def dom_identifier
        @dom_identifier ||= begin
          name = attribute_name
          id = @builder.object.id || "_new_#{ parent_nested_field&.attribute_name }_"
          time = (Time.now.to_f * 1000).to_i
          random = (rand * 1000).to_i
          [name, id, time, random].join('-')
        end
      end

      def subclass
        @subclass ||= options.fetch(:subclass, subclasses.presence)
      end

      def subclasses
        options.fetch(
          :subclasses,
          (model.try(:descendants) || []).sort_by { |m| m.model_name.human }
        )
      end
      
      def add_button_label
        options.fetch(:add_button_label) { I18n.t('para.form.nested.add') }
      end

      def add_button_class
        options.fetch(:add_button_class) { 'btn-primary' }
      end

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
