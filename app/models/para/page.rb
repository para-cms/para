module Para
  class Page < ActiveRecord::Base
    extend FriendlyId
    friendly_id :title, use: [:slugged, :finders, :history]

    belongs_to :component, class_name: 'Para::Component::Base'

    validates :title, presence: true

    def should_generate_new_friendly_id?
      slug.blank? || title_changed?
    end
  end
end
