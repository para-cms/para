module Para
  module FormBuilder
    module NestedForm
      # FIXME : When we have a nested field that maps to an STI model, the _id
      #         field is passed instead of the relation, and the inverse_of
      #         guard doesn't work
      #
      def nested_fields
        @nested_fields ||= fields.reject do |field|
          inverse_of?(field.name)
        end
      end

      def nested_resource_name
        @nested_resource_name ||= begin
          name_method = Para.config.resource_name_methods.find do |method_name|
            object.respond_to?(method_name)
          end

          (name_method && object.try(name_method).presence) || default_resource_name
        end
      end

      def nested_resource_dom_id
        return "" unless nested?

        @nested_resource_dom_id ||= [
          object.class.model_name.singular,
          (Time.now.to_f * 1000).to_i,
          (object.id || "_new_#{ nested_attribute_name }_id")
        ].join('-')
      end

      def remove_association_button
        return "" unless allow_destroy?

        template.content_tag(:div, class: 'panel-btns') do
          template.link_to_remove_association(
            self, wrapper_class: 'form-fields', class: 'btn btn-danger btn-xs'
          ) do
            ::I18n.t('para.form.nested.remove')
          end
        end
      end

      def allow_destroy?
        return false unless nested?

        nested_options = parent_object.nested_attributes_options
        relation = nested_options[nested_attribute_name]
        relation && relation[:allow_destroy]
      end

      def inverse_of?(field_name)
        return false unless nested?

        reflection = parent_object.class.reflect_on_association(nested_attribute_name)
        reflection && (reflection.options[:inverse_of].to_s == field_name.to_s)
      end

      def nested?
        nested_attribute_name.present?
      end

      def nested_attribute_name
        options[:nested_attribute_name] ||=
          if (match = object_name.match(/\[(\w+)_attributes\]/))
            match[1]
          end
      end

      def parent_object
        nested? && options[:parent_builder] && options[:parent_builder].object
      end

      private

      def default_resource_name
        model_name = object.class.model_name.human
        id_or_new = (id = object.id) ? id : ::I18n.t('para.form.nested.new')

        [model_name, id_or_new].join(' - ')
      end
    end
  end
end
