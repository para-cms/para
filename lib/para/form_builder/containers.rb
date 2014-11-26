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
                para_submit_button + para_cancel_button
              end
            end
          end
        end
      end

      def para_submit_button
        button(:submit, I18n.t('para.shared.save'), class: 'btn-success')
      end

      def para_cancel_button
        template.link_to(
          I18n.t('para.shared.cancel'),
          template.component_path(template.instance_variable_get(:@component)),
          class: 'btn btn-default'
        )
      end
    end
  end
end
