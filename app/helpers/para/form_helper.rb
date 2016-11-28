module Para
  module FormHelper
    def para_form_for(resource, options = {}, &block)
      default_options = {
        as: :resource,
        wrapper: :vertical_form,
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

      if options.fetch(:fixed_actions, true)
        default_options[:html][:class] << ' form-fixed-actions'
      end

      simple_form_for(resource, options) do |form|
        capture { block.call(form) }.tap do |content|
          # Append hidden field with type if resource is subclassable
          # to avoid bad class instantiation in create action
          if @component.subclassable? && resource.new_record?
            content << form.hidden_field(:type, value: resource.type)
          end
        end
      end
    end
  end
end
