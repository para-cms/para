module Para
  module Inputs
    class NestedManyInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-many"

        model = @builder.object.class
        nested = model && model.nested_attributes_options[attribute_name]
        allow_destroy = nested && nested[:allow_destroy]
        reorderable = model.reflections[attribute_name].klass.orderable?

        template.render(
          partial: 'para/inputs/nested_many',
          locals: {
            form: @builder,
            input_html_options: input_html_options,
            attribute_name: attribute_name,
            allow_destroy: allow_destroy,
            reorderable: reorderable,
            dom_identifier: dom_identifier
          }
        )
      end

      def dom_identifier
        @dom_identifier ||= begin
          name = attribute_name
          time = (Time.now.to_f * 1000).to_i
          random = (rand * 1000).to_i
          [name, time, random].join('-')
        end
      end
    end
  end
end
