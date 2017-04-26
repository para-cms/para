module Para
  module FormHelper
    def para_form_for(resource, options = {}, &block)
      default_options = {
        as: :resource,
        wrapper: :vertical_form,
        wrapper_mappings: Para::SimpleFormConfig.wrapper_mappings,
        track_attribute_mappings: true,
        html: { class: '', data: { :'para-form' => true } }
      }

      options = default_options.deep_merge(options)

      options[:html][:class] = [
        options[:html][:class].presence,
        'form-vertical forms-outline'
      ].compact.join(' ')

      unless options.key?(:url)
        options[:url] = @component.relation_path(resource)
      end

      simple_form_for(resource, options) do |form|
        capture { block.call(form) }.tap do |content|
          # Append hidden field with type if resource is subclassable
          # to avoid bad class instantiation in create action
          if @component.subclassable? && resource.new_record?
            content << form.hidden_field(:type, value: resource.type)
          end

          content << form.attributes_mappings_field_for(form)
        end
      end
    end
  end
end
