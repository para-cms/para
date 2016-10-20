module Para
  module AttributeField
    class ImageField < AttributeField::Base
      include ActionView::Helpers::AssetTagHelper

      register :image, self

      def value_for(instance)
        style = attachment_thumb_style_for(instance)

        if instance.send(:"#{ name }?")
          image_tag(instance.send(name).url(style))
        end
      end

      def excerptable_value?
        false
      end

      private

      def attachment_thumb_style_for(instance)
        styles = instance.send(name).styles.map(&:first)
        # Check if there's a :thumb or :thumbnail style in attachment definition
        thumb = styles.find { |s| %w(thumb thumbnail).include?(s.to_s) }
        # Return the potentially smallest size !
        thumb || styles.first || :original
      end
    end
  end
end
