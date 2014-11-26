module Para
  module Markup
    class Panel < Para::Markup::Component
      def container(options = {}, &block)
        merge_class!(options, "panel")

        if (type = options.fetch(:type, 'default'))
          merge_class!(options, "panel-#{ type }")
        end

        content_tag(:div, options) do
          capture { block.call(self) }
        end
      end

      def header(options = {}, &block)
        merge_class!(options, "panel-heading")

        content_tag(:div, options) do
          capture { block.call }
        end
      end

      def body(options = {}, &block)
        merge_class!(options, "panel-body")

        content_tag(:div, options) do
          capture { block.call }
        end
      end

      def footer(options = {}, &block)
        merge_class!(options, "panel-footer")

        content_tag(:div, options) do
          capture { block.call }
        end
      end
    end
  end
end
