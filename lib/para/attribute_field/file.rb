module Para
  module AttributeField
    class FileField < AttributeField::Base
      include ActionView::Helpers::UrlHelper

      register :file, self

      field_option :wrapper, :wrapper_name

      def value_for(instance)
        if instance.send(:"#{ name }?")
          url = instance.send(name).url
          link_to(url, url)
        end
      end

      def excerptable_value?
        false
      end

      def wrapper_name
        :horizontal_file_input
      end
    end
  end
end
