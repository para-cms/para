module Para
  module FormBuilder
    module Ordering
      def orderable?
        options.fetch(:orderable, object.class.orderable?)
      end

      def reorder_anchor(options = {})
        return "" unless orderable?

        options[:class] ||= ''
        options[:class] = [options[:class], 'panel-order-anchor'].join(' ')

        template.content_tag(:span, class: options[:class]) do
          template.content_tag(:i, '', class: 'fa fa-bars') +
          hidden_field(:position, class: 'resource-position-field')
        end
      end
    end
  end
end
