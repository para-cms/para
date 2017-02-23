module Para
  module TreeHelper
    def needs_placeholder?(node)
      node.children.empty? && node.depth < max_depth_for(node.class)
    end

    def max_depth_for(model)
      model.max_depth || Para.config.default_tree_max_depth
    end

    def actions(resource)
      edit_button(resource) + delete_button(resource)
    end

    def edit_button(resource)
      link_to(
        component.relation_path(
          resource, action: :edit, return_to: view.request.fullpath
        ),
        class: 'btn btn-sm btn-icon-primary btn-shadow hint--left',
        aria: {
          label: ::I18n.t('para.shared.edit')  
        }
      ) do
        content_tag(:i, '', class: 'fa fa-pencil')
      end
    end

    def delete_button(resource)
      link_to(
        component.relation_path(resource),
        method: :delete,
        data: {
          confirm: ::I18n.t('para.list.delete_confirmation')
        },
        class: 'btn btn-sm btn-icon-danger btn-shadow hint--left',
        aria: {
          label: ::I18n.t('para.shared.destroy')  
        }
      ) do
        content_tag(:i, '', class: 'fa fa-times')
      end
    end
  end
end
