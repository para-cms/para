module Para
  module Library
    class File < ActiveRecord::Base
      has_attached_file :attachment

      validates :attachment, presence: true
      do_not_validate_attachment_file_type :attachment
    end
  end
end
