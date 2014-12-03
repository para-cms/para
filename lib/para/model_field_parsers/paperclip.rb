module Para
  module ModelFieldParsers
    class Paperclip < Para::ModelFieldParsers::Base
      register :paperclip, self

      def parse!
        model.attachment_definitions.each do |key, _|
          paperclip_suffixes.each do |suffix|
            field_name = [key, suffix].join('_').to_sym
            @fields_hash.delete(field_name)
          end

          @fields_hash[key] = AttributeField::ImageField.new(
            model, name: key, type: 'image', field_type: 'image'
          )
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
    end
  end
end
