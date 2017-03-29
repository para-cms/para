module Para
  module SearchResultsHelper
    def selected_item_for(result)
      content_tag(:tr, class: 'selected-item', data: { :'selected-item-id' => result.id }) do
        content_tag(:td, reorder_anchor, class: 'reorder-anchor-cell') +
        content_tag(:td, resource_name(result)) +

        content_tag(:td, class: 'remove-button-cell') do
          button_tag type: :button, class: 'btn btn-xs btn-danger', data: { :'remove-item' => true } do
            fa_icon 'arrow-left'
          end
        end
      end
    end
  end
end
