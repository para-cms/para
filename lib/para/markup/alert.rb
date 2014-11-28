module Para
  module Markup
    class Alert < Para::Markup::Component
      def container(message, options = {}, &block)
        if block
          options = message
          message = capture { block.call }
        end

        type = options.delete(:type) || 'info'

        merge_class!(options, "alert")
        merge_class!(options, "alert-#{ type }")

        dismissable = !options.key?(:dismissable) || options.delete(:dismissable)

        merge_class!(options, "alert-dismissable") if dismissable

        content_tag :div, options do
          if dismissable
            close_button + message
          else
            message
          end
        end
      end

      private

      def close_button
        content_tag(:button, type: "button", class: "close", "data-dismiss" => "alert") do
          content_tag(:span, '&times;'.html_safe)
        end
      end
    end
  end
end
