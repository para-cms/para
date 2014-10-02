module Para
  module Inputs
    class NestedManyInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-many"

        model = @builder.object.class
        nested = model && model.nested_attributes_options[attribute_name]
        allow_destroy = nested && nested[:allow_destroy]
        reorderable = false

        columns_length = 1
        columns_length += 1 if allow_destroy
        columns_length += 1 if reorderable

        template.render(
          partial: 'para/inputs/nested_many',
          locals: {
            form: @builder,
            input_html_options: input_html_options,
            attribute_name: attribute_name,
            allow_destroy: allow_destroy,
            reorderable: reorderable,
            columns_length: columns_length
          }
        )
      end
    end
  end
end
