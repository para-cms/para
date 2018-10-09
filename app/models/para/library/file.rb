module Para
  module Library
    class File < ActiveRecord::Base
      if defined?(ActiveStorage)
        has_one_attached :attachment

        # Return attachment.path or attachment.url depending on the storage
        # backend, allowing 'openuri' and 'roo' libraries to load easily the
        # file at the right path, on filesystem or othe storage systems, like S3.
        #
        def attachment_path
          return unless attachment.attached?

          attachment.service_url
        end

        alias_method :attachment_url, :attachment_path

        def attachment_ext
          ::File.extname(attachment.filename.to_s) if attachment.attached?
        end
      else
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

        def attachment_url
          attachment.url if attachment?
        end

        def attachment_ext
          ::File.extname(attachment_file_name) if attachment.attached?
        end
      end
    end
  end
end
