module Para
  module ModelFieldParsers
    class Paperclip < Para::ModelFieldParsers::Base
      register :paperclip, self

      def parse!
        model.attachment_definitions.each do |key, options|
          paperclip_suffixes.each do |suffix|
            field_name = [key, suffix].join('_').to_sym
            @fields_hash.delete(field_name)
          end

          @fields_hash[key] = if image?(options)
            AttributeField::ImageField.new(
              model, name: key, type: 'image', field_type: 'image'
            )
          else
            AttributeField::FileField.new(
              model, name: key, type: 'file', field_type: 'file'
            )
          end
        end
      end

      def applicable?
        model.respond_to?(:attachment_definitions)
      end

      private

      def paperclip_suffixes
        [
          :file_name,
          :content_type,
          :file_size,
          :updated_at
        ]
      end

      # For our default, we tell that an attachment is an image if it
      # has at least one style and that this style starts with a digit or the
      # "x" letter, which is used for styles like "x200" to only force height
      #
      def image?(options)
        if (styles = options[:styles]) && !styles.empty?
          styles.values.first.is_a?(String) &&
            styles.values.first.match(/^(\d|x)/i)
        end
      end
    end
  end
end
