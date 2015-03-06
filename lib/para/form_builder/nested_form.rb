module Para
  module FormBuilder
    module NestedForm
      def nested_fields
        @nested_fields ||= fields.reject do |field|
          inverse_of?(field.name)
        end
      end

      def nested_resource_name
        @nested_resource_name ||= object.try(:name) || object.try(:title) || [
          object.class.model_name.human,
          (
            (id = object.id) ? id : I18n.t('para.form.nested.new')
          )
        ].join(' - ')
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

        template.content_tag(:div, class: 'panel-btns pull-right') do
          template.link_to_remove_association(
            self, wrapper_class: 'form-fields', class: 'btn btn-danger'
          ) do
            template.content_tag(:i, '', class: 'fa fa-trash') +
            I18n.t('para.form.nested.remove')
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
        reflection && (reflection.options[:inverse_of] == field_name)
      end

      def nested?
        nested_attribute_name.present?
      end

      def nested_attribute_name
        options[:nested_attribute_name]
      end

      def parent_object
        nested? && options[:parent_builder] && options[:parent_builder].object
      end
    end
  end
end
