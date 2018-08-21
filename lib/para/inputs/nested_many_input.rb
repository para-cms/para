module Para
  module Inputs
    class NestedManyInput < NestedBaseInput
      attr_reader :resource

      def input(wrapper_options = nil)
        input_html_options[:class] << "nested-many"

        orderable = options.fetch(:orderable, model.orderable?)
        add_button = options.fetch(:add_button, true)
        # Load existing resources
        resources = object.send(attribute_name)
        # Order them if the list should be orderable
        resources = resources.sort_by(&:position) if orderable

        locals = options.fetch(:locals, {})

        with_global_nested_field do
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
              subclass: subclass,
              subclasses: subclasses,
              inset: inset?,
              add_button_label: add_button_label,
              add_button_class: add_button_class,
              render_partial: render_partial?
            }
          )
        end
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

      def inset?
        options.fetch(:inset, false)
      end

      def add_button_label
        options.fetch(:add_button_label) { I18n.t('para.form.nested.add') }
      end

      def add_button_class
        options.fetch(:add_button_class) { 'btn-primary' }
      end

      def render_partial?
        options[:render_partial] || object.errors.any? || (object.persisted? && inset?)
      end
    end
  end
end
