module Para
  module Component
    class Page < Para::Component::Base
      register :page, self

      has_one :page, class_name: 'Para::Page', autosave: true,
                     inverse_of: :component, foreign_key: :component_id,
                     dependent: :destroy

      validates :page, presence: true

      before_validation :build_page_unless_exists

      delegate :slug, to: :page, allow_nil: true

      def build_page_unless_exists
        build_page(title: name) unless page
      end

      def to_param
        slug || id
      end
    end
  end
end