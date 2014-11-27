module Para
  module Inputs
    class NestedManyInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-many"

        parent_model = @builder.object.class
        model = parent_model.reflections[attribute_name].klass
        orderable = options.fetch(:orderable, model.orderable?)
        add_button = options.fetch(:add_button)

        template.render(
          partial: 'para/inputs/nested_many',
          locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            orderable: orderable,
            add_button: add_button,
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
