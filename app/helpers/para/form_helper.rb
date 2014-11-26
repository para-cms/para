module Para
  module FormHelper
    def para_form_for(resource, options = {}, &block)
      default_options = {
        as: :resource,
        wrapper: :vertical_form,
        html: { class: 'form-vertical' }
      }

      options = default_options.deep_merge(options)

      unless options.key?(:url)
        options[:url] = component_relation_path(@component, resource.class.name, resource)
      end

      simple_form_for(resource, options, &block)
    end
  end
end
