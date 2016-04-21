module Para
  module Inputs
    class NestedManyInput < SimpleForm::Inputs::Base
      attr_reader :resource

      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-many"

        orderable = options.fetch(:orderable, model.orderable?)
        add_button = options.fetch(:add_button, true)
        # Load existing resources
        resources = object.send(attribute_name)
        # Order them if the list should be orderable
        resources = resources.order(:position) if orderable

        locals = options.fetch(:locals, {})

        template.render(
          partial: 'para/inputs/nested_many',
          locals: {
            form: @builder,
            model: model,
            attribute_name: attribute_name,
            orderable: orderable,
            add_button: add_button,
            dom_identifier: dom_identifier,
            resources: resources,
            nested_locals: locals,
            subclass: subclass
          }
        )
      end

      def parent_model
        @parent_model ||= @builder.object.class
      end

      def model
        @model ||= parent_model.reflect_on_association(attribute_name).klass
      end

      def dom_identifier
        @dom_identifier ||= begin
          name = attribute_name
          time = (Time.now.to_f * 1000).to_i
          random = (rand * 1000).to_i
          [name, time, random].join('-')
        end
      end

      def subclass
        @subclass ||= options.fetch(
          :subclass,
          model.respond_to?(:descendants) && model.descendants.length > 0
        )
      end
    end
  end
end
