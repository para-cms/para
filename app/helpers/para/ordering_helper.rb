module Para
  module OrderingHelper
    def reorder_anchor(options = {})
      options[:class] ||= ''
      options[:class] = [options[:class], 'order-anchor'].join(' ')

      field = if (form = options.delete(:form))
        form.hidden_field(:position, class: 'resource-position-field')
      else
        value = options.delete(:value) || 0
        hidden_field_tag(:position, value, class: 'resource-position-field')
      end

      content_tag(:span, options) do
        content_tag(:i, '', class: 'fa fa-arrows') +
        field
      end
    end
  end
end
