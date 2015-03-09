module Para
  module TreeHelper
    def can_insert_children?(node)
      node.children.empty? && node.depth < max_depth_for(node.class)
    end

    def max_depth_for(model)
      model.max_depth || Para.config.default_tree_max_depth
    end

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
        content_tag(:i, '', class: 'fa fa-bars') +
        field
      end
    end
  end
end
