module Para
  module FormBuilder
    module Containers
      def fieldset(options = {}, &block)
        template.content_tag(:div, class: 'block form-inputs') do
          buffer = if (title = options[:title])
            template.content_tag(:div, class: 'form-group') do
              template.content_tag(:legend, title)
            end
          else
            ''.html_safe
          end

          buffer + template.capture(&block)
        end
      end

      def actions(options = {}, &block)
        template.content_tag(:div, class: 'block form-actions form-group') do
          template.content_tag(:div, class: 'col-sm-9 col-sm-offset-3') do
            if block
              template.capture(&block)
            else
              if options.empty?
                options[:only] = template.instance_variable_get(:@component).default_form_actions
              end
              actions_buttons_for(options).join("\n").html_safe
            end
          end
        end
      end

      def actions_buttons_for(options)
        names = [:submit, :submit_and_edit, :submit_and_add_another, :cancel]

        names.select! { |name| Array.wrap(options[:only]).include?(name) } if options[:only]
        names.reject! { |name| Array.wrap(options[:except]).include?(name) } if options[:except]
        buttons = names.map { |name| send(:"para_#{ name }_button") }
        buttons.unshift(return_to_hidden_field)
        buttons
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
        template.params[:return_to].presence || component_path
      end

      def component_path
        if (component = template.instance_variable_get(:@component))
          component.path
        end
      end
    end
  end
end
