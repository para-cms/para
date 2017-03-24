module Para
  module Page
    module Model
      extend ActiveSupport::Concern

      included do
        has_many :sections, -> { ordered }, class_name: '::Para::Page::Section',
                                            as: :page,
                                            dependent: :destroy
        accepts_nested_attributes_for :sections, allow_destroy: true
      end
    end
  end
end
