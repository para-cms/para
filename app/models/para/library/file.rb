module Para
  module Library
    class File < ActiveRecord::Base
      has_attached_file :attachment

      validates :attachment, presence: true
      do_not_validate_attachment_file_type :attachment

      # Return attachment.path or attachment.url depending on the storage
      # backend, allowing 'openuri' and 'roo' libraries to load easily the
      # file at the right path, on filesystem or othe storage systems, like S3.
      #
      def attachment_path
        return unless attachment?

        case attachment.options[:storage]
        when :filesystem then attachment.path
        else attachment.url
        end
      end
    end
  end
end
