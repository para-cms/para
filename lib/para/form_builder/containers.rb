module Para
  module FormBuilder
    module Containers
      def fieldset(&block)
        template.content_tag(:div, class: 'row') do
          template.content_tag(:div, class: 'col-md-12 col-lg-8') do
            template.content_tag(:div, class: 'block form-inputs') do
              template.capture(&block)
            end
          end
        end
      end

      def actions(&block)
        template.content_tag(:div, class: 'row') do
          template.content_tag(:div, class: 'col-md-12 col-lg-8') do
            template.content_tag(:div, class: 'block form-actions') do
              if block
                template.capture(&block)
              else
                [
                  return_to_hidden_field,
                  para_submit_button,
                  para_submit_and_edit_button,
                  para_submit_and_add_another_button,
                  para_cancel_button
                ].join("\n").html_safe
              end
            end
          end
        end
      end

      def return_to_hidden_field
        template.hidden_field_tag(:return_to, return_to_path)
      end

      def para_submit_button(options = {})
        button(:submit, I18n.t('para.shared.save'), name: '_save', class: 'btn-success')
      end

      def para_submit_and_edit_button
        button(:submit, I18n.t('para.shared.save_and_edit'), name: '_save_and_edit', class: 'btn-primary')
      end

      def para_submit_and_add_another_button
        button(:submit, I18n.t('para.shared.save_and_add_another_button'), name: '_save_and_add_another', class: 'btn-primary')
      end

      def para_cancel_button
        template.link_to(
          I18n.t('para.shared.cancel'),
          return_to_path,
          class: 'btn btn-danger'
        )
      end

      def return_to_path
        template.params[:return_to].presence ||
          template.component_path(template.instance_variable_get(:@component))
      end
    end
  end
end
