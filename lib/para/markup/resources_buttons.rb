module Para
  module Markup
    class ResourcesButtons < Para::Markup::Component
      attr_reader :component
      
      def initialize(component, view)
        @component = component
        super(view)
      end

      def clone_button(resource)
        return unless resource.class.cloneable?

        path = component.relation_path(
          resource, action: :clone, return_to: view.request.fullpath
        )

        options = {
          method: :post,
          class: 'btn btn-sm btn-icon-info btn-shadow hint--left',
          aria: {
            label: ::I18n.t('para.shared.copy')
          }
        }

        view.link_to(path, options) do
          content_tag(:i, '', class: 'fa fa-copy')
        end
      end

      def edit_button(resource)
        path = component.relation_path(
          resource, action: :edit, return_to: view.request.fullpath
        )

        view.link_to(path, class: 'btn btn-sm btn-icon-primary btn-shadow hint--left', aria: { label: ::I18n.t('para.shared.edit') }) do
          content_tag(:i, '', class: 'fa fa-pencil')
        end
      end

      def delete_button(resource)
        path = component.relation_path(resource, return_to: view.request.fullpath)

        options = {
          method: :delete,
          data: {
            confirm: ::I18n.t('para.list.delete_confirmation')
          },
          class: 'btn btn-sm btn-icon-danger btn-shadow hint--left',
          aria: {
            label: ::I18n.t('para.shared.destroy')
          }
        }

        view.link_to(path, options) do
          content_tag(:i, '', class: 'fa fa-times')
        end
      end
    end
  end
end