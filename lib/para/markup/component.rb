module Para
  module Markup
    class Component
      attr_reader :view

      delegate :content_tag, :capture, to: :view

      def initialize view
        @view = view
      end

      protected

      def merge_class!(options, klass)
        options[:class] ||= ""
        options[:class] += " #{ klass }"
      end
    end
  end
end
