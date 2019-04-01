module Para
  module Cloneable
    class AttachmentsCloner
      attr_reader :original, :clone

      def initialize(original, clone)
        @original = original
        @clone = clone
      end
      
      def clone!
        return unless defined?(ActiveStorage)
        
        attachment_reflections = original.class.reflections.select { |k, v| 
          k.to_s.match(/_attachment\z/) && 
          v.options[:class_name] == "ActiveStorage::Attachment" 
        }

        attachment_reflections.each do |name, reflection|
          original_attachment = original.send(name)
          next unless original_attachment
          
          association_name = name.gsub(/_attachment\z/, "")

          Para::ActiveStorageDownloader.new(original_attachment).download_blob_to_tempfile do |tempfile|
            clone.send(association_name).attach({
              io: tempfile,
              filename: original_attachment.blob.filename,
              content_type: original_attachment.blob.content_type
            })
          end
        end
      end
    end
  end
end