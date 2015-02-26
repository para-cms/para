module Para
  module Markup
    class ResourcesTree < Para::Markup::Component
      attr_reader :model, :component, :actions

      def container(options = {}, &block)
        @model = options.delete(:model)
        @component = options.delete(:component)

        merge_class!(options, 'roots')
        merge_class!(options, 'sortable')
        merge_class!(options, 'connectedSortable')

        tree = content_tag(:ul, options) do
          capture { block.call(self) }
        end

        tree
      end

      def actions_cell(resource)
        content_tag(:td) do
          content_tag(:div, class: 'pull-right btn-group') do
            edit_button(resource) + delete_button(resource)
          end
        end
      end

      def edit_button(resource)
        view.link_to(
          component.relation_path(
            resource, action: :edit, return_to: view.request.fullpath
          ),
          class: 'btn btn-primary'
        ) do
          content_tag(:i, '', class: 'fa fa-pencil')
        end
      end

      def delete_button(resource)
        view.link_to(
          component.relation_path(resource),
          method: :delete,
          data: {
            confirm: I18n.t('para.list.delete_confirmation')
          },
          class: 'btn btn-danger'
        ) do
          content_tag(:i, '', class: 'fa fa-trash')
        end
      end
    end
  end
end
