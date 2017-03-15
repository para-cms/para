module Para
  module Inputs
    class MultiSelectInput < SimpleForm::Inputs::Base
      attr_reader :resource

      def input(wrapper_options = nil)
        input_html_options[:class] << "multi-select"

        orderable = options.fetch(:orderable, model.orderable?)
        # Load existing resources
        resources = object.send(attribute_name)
        # Order them if the list should be orderable
        resources = resources.sort_by(&:position) if orderable

        template.render(
          partial: 'para/inputs/multi_select',
          locals: {
            form: @builder,
            model: model,
            attribute_name: reflection.foreign_key.pluralize,
            orderable: orderable,
            resources: resources
          }
        )
      end

      def parent_model
        @parent_model ||= @builder.object.class
      end

      def model
        @model ||= reflection.klass
      end

      def reflection
        @reflection ||= parent_model.reflect_on_association(attribute_name)
      end
    end
  end
end
