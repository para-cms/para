module Para
  module Inputs
    class NestedOneInput < SimpleForm::Inputs::Base
      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-one"

        parent_model = object.class
        model = parent_model.reflect_on_association(attribute_name).klass
        resource = object.send(:"#{ attribute_name }") ||
                    object.send(:"#{ attribute_name }=", model.new)

        template.render(
          partial: 'para/inputs/nested_one',
          locals: {
            form: @builder,
            model: model,
            resource: resource,
            attribute_name: attribute_name
          }
        )
      end
    end
  end
end
