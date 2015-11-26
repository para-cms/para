module Para
  module Markup
    class ResourceTree < Para::Markup::Component
      def tree_list(resources, options = {}, &block)
        options[:class] ||= ''
        options[:class] << ' tree-list'

        content_tag(:ul, options) do
          resources.each do |resource|
            block.call(resource)
          end
        end
      end

      def tree_node(resource: nil, label: nil, children: [], **options, &block)
        options[:class] ||= ''
        options[:class] << ' node'

        content_tag(:li, options) do
          node_row(resource, label) + 
          node_children(children, &block)
        end
      end

      def node_row(resource, label)
        content_tag(:div, class: 'node-row') do
          label
        end
      end

      def node_children(children, &block)
        tree_list(children, &block) if children.length > 0
      end
    end
  end
end
