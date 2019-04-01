module Para
  class ActiveStorageDownloader
    if defined?(ActiveStorage)
      include ActiveStorage::Downloading
    end

    attr_reader :attachment
    
    delegate :blob, to: :attachment

    def initialize(attachment)
      @attachment = attachment
    end

    if defined?(ActiveStorage)
      public :download_blob_to_tempfile
    else
      define_method(:download_blob_to_tempfile) do
        raise NoMethodError, "ActiveStorage is not included in your application"
      end
    end
  end
end