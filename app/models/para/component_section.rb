module Para
  class ComponentSection < ActiveRecord::Base
    has_many :components, -> { ordered }, class_name: 'Para::Component::Base',
             autosave: true, foreign_key: :component_section_id,
             dependent: :destroy

    scope :ordered, -> { order(position: :asc) }

    validates :identifier, presence: true

    def name
      read_attribute(:name) || ::I18n.t(
        "components.section.#{ identifier }",
        default: identifier.humanize
      )
    end
  end
end
